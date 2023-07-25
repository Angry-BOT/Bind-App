import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import 'home_view_model_provider.dart';
import 'near_by_stores_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recommendedStoresViewModelProvider =
    ChangeNotifierProvider<RecommendedStoresViewModel>(
  (ref) {
    ref.watch(homeViewModelProvider.select((value) => value.address!.point));
    final model = RecommendedStoresViewModel(ref);
    model.getStores();
    return model;
  },
);

class RecommendedStoresViewModel extends ChangeNotifier {
  final Ref ref;
  RecommendedStoresViewModel(this.ref);

  StoreRepository get _repository => ref.read(storeRepositoryProvider);

  List<DocumentSnapshot> _snapshots = [];

  List<Store> _nears = [];

  List<Store> get _nears1 {
    final list = _nears.where((element) => element.canBeRec).toList();
    list.sort((a, b) => b.rating.compareTo(a.rating));
    print("near canberec : ${list.map((e) => e.name).toList()}");
    return list;
  }

  List<Store> get _nears2 {
    final list = _nears.where((element) => !element.canBeRec).toList();
    list.sort((a, b) => b.rating.compareTo(a.rating));
    print("near can not be rec : ${list.map((e) => e.name).toList()}");
    return list;
  }

  List<Store> get stores {
    final list = _snapshots.map((e) => Store.fromFirestore(e)).toList();
    print("nearby: ${list.map((e) => e.name).toList()}");

    final list2 = list + _nears1;
    list2.sort((a, b) => b.rating.compareTo(a.rating));
    final list3 = list2 + _nears2;
    return list3.where((element) => list3.indexOf(element) < _length).toList();
  }

  List<Store> get stores5 =>
      stores.where((e) => stores.indexOf(e) < 5).toList();

  int get _length => 5 + _calls * 4;

  int _calls = 0;
  int get calls => _calls;
  set calls(int calls) {
    _calls = calls;
    notifyListeners();
  }

  Future<void> getStores() async {
    try {
      _snapshots = await _repository.storesLimitFuture(limit: 6);
      _nears = await ref.read(nearByStoresProvider.future);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  bool loading = true;
  bool busy = false;
  Future<void> getStoresMore() async {
    busy = true;
    var previous = _snapshots;
    calls++;
    try {
      _snapshots = _snapshots +
          await _repository.storesLimitFuture(limit: 4, last: _snapshots.last);
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
}
