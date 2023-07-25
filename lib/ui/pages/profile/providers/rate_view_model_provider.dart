import 'dart:io';

import '../../home/providers/home_view_model_provider.dart';

import '../../../../model/failed_deal.dart';
import '../../../../model/profile.dart';
import '../../../../model/rate.dart';
import '../../../../repository/rating_repository.dart';
import 'profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rateViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<RateViewModel, String>(
  (ref, id) => RateViewModel(ref, id),
);

final reviewedProvider = StateProvider<List<String>>((ref) => []);

class RateViewModel extends ChangeNotifier {
  final Ref _ref;
  final String _id;
  RateViewModel(this._ref, this._id);

  Profile get _profile => _ref.read(profileProvider).value!;

  RatingRepository get _repository => _ref.read(ratingRepositoryProvider);

  bool? _fulFill;

  bool? get fulFill => _fulFill;
  set fulFill(bool? fullFill) {
    _fulFill = fullFill;
    notifyListeners();
  }

  bool? _quality;
  bool? get quality => _quality;
  set quality(bool? quality) {
    _quality = quality;
    notifyListeners();
  }

  double? _rating;
  double? get rating => _rating;
  set rating(double? rating) {
    _rating = rating;
    notifyListeners();
  }

  List<File> files = [];

  void addFile(File file) {
    files.add(file);
    notifyListeners();
  }

  void removeFile(File file) {
    files.remove(file);
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String _review = '';
  String get review => _review;
  set review(String review) {
    _review = review;
    notifyListeners();
  }

  bool get ready =>
      fulFill != null && quality != null && rating != null && review.isNotEmpty;

  void submit({required String enquiryId, required VoidCallback onDone}) async {
    final rate = Rate(
      id: '',
      storeId: _id,
      customerId: _profile.id,
      customerName: "${_profile.firstName} ${_profile.lastName}",
      fulFill: fulFill!,
      quality: quality!,
      rating: rating!,
      images: [],
      review: review,
      createdAt: DateTime.now(),
      enquiryId: enquiryId,
      publish: true,
      city: _ref.read(homeViewModelProvider).address!.city,
    );
    loading = true;
    try {
      await _repository.rate(rate, files);
      _ref.read(reviewedProvider.state).state =
          _ref.read(reviewedProvider.state).state + [enquiryId];
      onDone();
      loading = false;
    } catch (e) {
      print(e);
      loading = false;
    }
  }

  String? _reason;
  String? get reason => _reason;
  set reason(String? reason) {
    _reason = reason;
    notifyListeners();
  }

  String? _wrongMessage;
  String? get wrongMessage => _wrongMessage;
  set wrongMessage(String? wrongMessage) {
    _wrongMessage = wrongMessage;
    notifyListeners();
  }

  void submitFailedDeal(String enquiryId, String eId) {
    try {
      _repository.submitFailedDeal(
        FailedDeal(
          createdAt: DateTime.now(),
          id: '',
          storeId: _id,
          customerId: _profile.id,
          customerName: "${_profile.firstName} ${_profile.lastName}",
          enquiryId: enquiryId,
          message: wrongMessage!,
          reason: reason!,
          eId: eId,
        ),
      );
      _ref.read(reviewedProvider.state).state =
          _ref.read(reviewedProvider.state).state + [eId];
    } catch (e) {}
  }
}
