import '../../../../model/master_data.dart';
import '../../../../model/option.dart';
import 'master_data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addCreditsViewModelProvider =
    ChangeNotifierProvider((ref) => AddCreditsViewModel(ref));

class AddCreditsViewModel extends ChangeNotifier {
  final Ref _ref;
  AddCreditsViewModel(this._ref);

  MasterData get masterData => _ref.read(masterDataProvider).value!;

  int? _credits;
  int? get credits => _credits;
  set credits(int? credits) {
    _credits = credits;
    notifyListeners();
  }

  List<Option> get options {
    final list = masterData.options
        .where((element) =>
            element.startTime.isBefore(DateTime.now()) &&
            (element.endTime == null ||
                element.endTime!.isAfter(DateTime.now())))
        .toList();
    list.sort((a, b) => a.quantity.compareTo(b.quantity));
    return list;
  }

  Option? get applied {
    final list =
        options.where((element) => element.quantity <= (credits ?? 0)).toList();
    if (list.isEmpty) {
      return null;
    }
    list.sort((a, b) => b.quantity.compareTo(a.quantity));
    return list.first;
  }

  Option? get may {
    final list =
        options.where((element) => element.quantity > (credits ?? 0)).toList();
    if (list.isEmpty) {
      return null;
    }
    list.sort((a, b) => a.quantity.compareTo(b.quantity));
    return list.first;
  }

  double? get _amount => credits != null
      ? applied != null
          ? applied!.amount(masterData.price, credits!)
          : credits! * masterData.price
      : null;

  double? get amount =>
      _amount != null ? double.tryParse(_amount!.toStringAsFixed(2)) : null;

  int? get finalCredit => credits != null
      ? applied != null
          ? ((applied!.extra != null ? credits! + applied!.extra! : credits))
          : credits
      : null;

  int? get extra => credits != null && applied != null && applied!.extra != null
      ? applied!.extra!
      : null;
  double? get discount =>
      credits != null && applied != null && applied!.discount != null
          ? applied!.discount!
          : null;
}
