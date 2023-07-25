import 'dart:io';

import 'package:bind_app/model/address.dart';
import 'package:bind_app/model/profile.dart';
import 'package:bind_app/ui/pages/home/providers/home_view_model_provider.dart';
import 'package:bind_app/ui/root.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../repository/profile_repository.dart';
import '../../../../utils/labels.dart';

final addDocumentsViewModelProvider =
    ChangeNotifierProvider((ref) => AddDocumentsViewModel(ref));

class AddDocumentsViewModel extends ChangeNotifier {
  final Ref _ref;

  AddDocumentsViewModel(this._ref);

  ProfileRepository get _profileRepo => _ref.read(profileRepositoryProvider);

  late Profile profile;

  String? _alreadyExistedAadhar;

  void _checkAadhar(String value) async {
    _alreadyExistedAadhar = await _profileRepo.getAlreadyExistedAadhar(value);
  }

  String? aadharValidator(String value) {
    if (value == _alreadyExistedAadhar) {
      return Labels.aadharCardWithSame;
    }
    return null;
  }

  bool get isReady =>
      _aadharId != null &&
      _aadharId!.length >= 11 &&
      _aadhar != null &&
      _aadhar2 != null &&
      _verification != null;

  String? _aadharId;
  set aadharId(String aadharId) {
    _aadharId = aadharId;
    if (aadharId.length == 12) {
      _checkAadhar(aadharId);
    }
    notifyListeners();
  }

  File? _aadhar;
  set aadhar(File? aadhar) {
    _aadhar = aadhar;
    notifyListeners();
  }

  File? _aadhar2;
  set aadhar2(File? aadhar2) {
    _aadhar2 = aadhar2;
    notifyListeners();
  }

  File? _verification;
  set verification(File? verification) {
    _verification = verification;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> completeProfile(
      {required VoidCallback onComplete, Address? address}) async {
    if (address != null) {
      final initial = _ref.read(homeViewModelProvider).address!;
      if (initial == address) {
        profile.addresses.remove(initial);
      }
      profile.addresses.add(address);
    } else {
      _ref.read(messageProvider).value = true;
    }
    loading = true;
    try {
      await _profileRepo.completeEnterprenaurProfile(
        profile: profile.copyWith(
          aadharId: _aadharId,
        ),
        aadhar: _aadhar,
        aadhar2: _aadhar2,
        verification: _verification,
      );
      onComplete();
      _loading = false;
    } catch (e) {
      print(e);
      loading = false;
    }
  }

  void skip() {
    _aadharId = null;
    _aadhar = null;
    _aadhar2 = null;
    _verification = null;
  }
}
