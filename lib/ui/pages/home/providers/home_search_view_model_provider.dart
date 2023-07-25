import 'package:bind_app/model/store_result.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/debouncer.dart';
import '../../../../repository/algolia_repository.dart';

final homeSearchStateProvider = StateProvider<bool>((ref)=> false);

final homeSearchViewModelProvider = ChangeNotifierProvider((ref){
  final model = HomeSearchViewModel(ref);
  model.init();
  return model;
});

class HomeSearchViewModel extends ChangeNotifier {
    final Ref _ref;

  HomeSearchViewModel(this._ref);
  AlgoliaRepository get _repo => _ref.read(algoliaRepositoryProvider);

  late Debouncer debouncer;

  void init() {
    debouncer = Debouncer(Duration(milliseconds: 500), (v) async {
      if (v.length < 3) {
        if (results.isNotEmpty) {
          results = [];
        }
        return;
      }
      loading = true;
      try {
        results = await _repo.search(v);
      } catch (e) {
        print(e);
      }
      loading = false;
    });
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  List<StoreResult> _results = [];
  List<StoreResult> get results => _results;
  set results(List<StoreResult> results) {
    _results = results;
    notifyListeners();
  }
}