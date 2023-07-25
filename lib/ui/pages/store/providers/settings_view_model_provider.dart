import 'dart:io';

import '../../../../repository/profile_repository.dart';
import '../../../../repository/store_repository.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsViewModelProvider =
    ChangeNotifierProvider<SettingsViewModel>((ref) => SettingsViewModel(ref));

class SettingsViewModel extends ChangeNotifier {
  final Ref ref;
  SettingsViewModel(this.ref);

  StoreRepository get _repository => ref.read(storeRepositoryProvider);
  ProfileRepository get _profileRepo => ref.read(profileRepositoryProvider);

  void setActive(bool value) {
    _repository.setActive(value);
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String? _udyogAadharNumber;
  String? get udyogAadharNumber => _udyogAadharNumber;
  set udyogAadharNumber(String? udyogAadharNumber) {
    if (udyogAadharNumber!.isEmpty) {
      _udyogAadharNumber = null;
    } else {
      _udyogAadharNumber = udyogAadharNumber;
      if (udyogAadharNumber.length == 12) {
        _checkUdyogAadhar(udyogAadharNumber);
      }
    }
    notifyListeners();
  }

  File? _udyogAadhar;
  File? get udyogAadhar => _udyogAadhar;
  set udyogAadhar(File? udyogAadhar) {
    _udyogAadhar = udyogAadhar;
    notifyListeners();
  }

  String? _alreadyExistedUdyogAadhar;

  void _checkUdyogAadhar(String value) async {
    _alreadyExistedUdyogAadhar =
        await _profileRepo.getAlreadyExistedUdyogAadhar(value);
  }

  bool get isReady =>
      udyogAadhar != null &&
      udyogAadharNumber != null &&
      udyogAadharNumber!.length == 11;

  String? udyogAadharValidator(String value) {
    if (value == _alreadyExistedUdyogAadhar) {
      return Labels.aadharCardWithSame;
    }
    return null;
  }


  void saveSubcategories(List<String> values) {
    try {
      _profileRepo.saveSubCategories(subcategories: values);
    } catch (e) {}
  }

  void addUdyogAadhar() async {
    loading = true;
    try {
      await _profileRepo.addUdyogAadhar(
          udyogAadharNumber: udyogAadharNumber!, file: udyogAadhar!);
    } catch (e) {
      print(e.toString());
    }
    loading = false;
  }
}
