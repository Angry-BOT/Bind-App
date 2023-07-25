import '../../auth/providers/auth_view_model_provider.dart';

import '../../../../model/transaction.dart';
import '../../../../repository/credits_repository_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final transactionFilterProvider = StateProvider<bool?>((ref) => null);

final transactionsViewModelProvider =
    ChangeNotifierProvider.family<TransactionsViewModel, bool?>(
  (ref, debit) {
    final model = TransactionsViewModel(
        ref, debit, ref.watch(authViewModelProvider).user!.uid);
    model.init();
    return model;
  },
);

class TransactionsViewModel extends ChangeNotifier {
  final Ref _ref;
  final bool? debit;
  final String uid;
  TransactionsViewModel(this._ref, this.debit, this.uid);

  CreditsRepository get _repository => _ref.read(creditsRepositoryProvider);

  List<DocumentSnapshot> _snapshots = [];
  List<CreditTransaction> get reviews =>
      _snapshots.map((e) => CreditTransaction.fromMap(e)).toList();

  Future<void> init() async {
    try {
      _snapshots = await _repository.transactionsLimitFuture(
          limit: 10, debit: debit, id: uid);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  bool loading = true;
  bool busy = false;
  Future<void> loadMore() async {
    if (_snapshots.isEmpty) {
      return;
    }
    busy = true;
    var previous = _snapshots;
    try {
      _snapshots = _snapshots +
          await _repository.transactionsLimitFuture(
              limit: 4, last: _snapshots.last, debit: debit, id: uid);
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
