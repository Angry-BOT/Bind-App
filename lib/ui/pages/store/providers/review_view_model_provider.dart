import '../../../../model/rate.dart';
import '../../../../repository/rating_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final reviewsViewModelProvider =
    ChangeNotifierProvider.family<ReviewsViewModel, String>(
  (ref, id) {
    final model = ReviewsViewModel(ref, id);
    model.init();
    return model;
  },
);

class ReviewsViewModel extends ChangeNotifier {
  final Ref _ref;
  final String id;
  ReviewsViewModel(this._ref, this.id);

  RatingRepository get _repository => _ref.read(ratingRepositoryProvider);

  List<Rate> updatedRates = [];

  List<DocumentSnapshot> _snapshots = [];
  List<Rate> get reviews => _snapshots
      .map(
        (e) => updatedRates.where((element) => element.id == e.id).isNotEmpty
            ? updatedRates.where((element) => element.id == e.id).first
            : Rate.fromMap(e),
      )
      .toList();

  Future<void> init() async {
    try {
      _snapshots = await _repository.reviewsLimitFuture(limit: 6, storeId: id);
      notifyListeners();
      _repository.updatedReviewsStream().listen((event) {
        updatedRates = event;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  bool loading = true;
  bool busy = false;
  Future<void> loadMore() async {
    busy = true;
    var previous = _snapshots;
    try {
      _snapshots = _snapshots +
          await _repository.reviewsLimitFuture(
              storeId: id, limit: 4, last: _snapshots.last);
      if (_snapshots.length == previous.length) {
        loading = false;
      } else {
        loading = true;
      }
    } catch (e) {
      print(e.toString());
    }
    busy = false;
    notifyListeners();
  }

  void reply(String _id, String value) {
    _repository.reply(id: _id, message: value);
  }
}
