import 'dart:io';
import 'dart:math';

import 'package:bind_app/ui/components/my_files.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../../model/profile.dart';
import '../../../../repository/profile_repository.dart';
import '../../auth/utils/auth_message.dart';
import 'profile_provider.dart';
import '../../../../utils/labels.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final editProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => EditProfileViewModel(ref));

class EditProfileViewModel extends ChangeNotifier {
  final Ref _ref;
  EditProfileViewModel(this._ref);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  ProfileRepository get _profileRepo => _ref.read(profileRepositoryProvider);

  Profile get _profile => _ref.read(profileProvider).value!;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  bool _loading2 = false;
  bool get loading2 => _loading2;
  set loading2(bool loading2) {
    _loading2 = loading2;
    notifyListeners();
  }

  String? get image => _profile.image;

  String? _firstName;
  String get firstName => _firstName ?? _profile.firstName;
  set firstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  String? _lastName;
  String get lastName => _lastName ?? _profile.lastName;
  set lastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  String? _emailAddress;
  String get emailAddress => _emailAddress ?? _profile.emailAddress;

  String get mobile => _profile.mobile;

  String? validateEmail(String v) {
    if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(v)) {
      return "Please enter valid email";
    } else if (v == _alreadyExistedEmail) {
      return Labels.emailIDAlreadyRegistered;
    }
    return null;
  }

  String? validateMobile(String v) {
    if ("+91$v" == _alreadyExistedMobile) {
      return Labels.phoneNumberAlreadyRegistered;
    }
    return null;
  }

  final List<String> _endings = ['.com', '.net', '.org', '.in','.co'];
  String? _alreadyExistedEmail;

  String? _alreadyExistedMobile;

  void _checkEmail(String value) async {
    for (var item in _endings) {
      if (value.endsWith(item)) {
        _alreadyExistedEmail = await _profileRepo.getAlreadyExistedEmail(value);
        print(_alreadyExistedEmail);
      }
    }
  }

  String? _about;
  String? get about => _about ?? _profile.about;
  set about(String? about) {
    _about = about;
    notifyListeners();
  }

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  void pickImage() async {
    final cropped = await MyImages.pickAndCrop();
    if (cropped != null) {
      file = cropped;
    }
  }

  bool get ready =>
      (firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          emailAddress.isNotEmpty) &&
      (firstName != _profile.firstName ||
          lastName != _profile.lastName ||
          emailAddress != _profile.emailAddress ||
          about != _profile.about ||
          file != null);

  void update({required VoidCallback onDone}) async {
    loading = true;
    try {
      await _profileRepo.update(
          _profile.copyWith(
            firstName: firstName,
            lastName: lastName,
            about: about,
            emailAddress: emailAddress,
          ),
          file: file);
      onDone();
    } catch (e) {
      print(e);
    }
    loading = false;
  }

  String _newMobile = '';
  String get newMobile => _newMobile;
  set newMobile(String newMobile) {
    _newMobile = newMobile;
    _resendToken = null;
    if (newMobile.length == 10) {
      _profileRepo
          .getAlreadyExistedMobile("+91$newMobile")
          .then((value) => _alreadyExistedMobile = value);
    }
    notifyListeners();
  }

  String _newEmail = '';
  String get newEmail => _newEmail;
  set newEmail(String newEmail) {
    _newEmail = newEmail;
    _checkEmail(newEmail);
    notifyListeners();
  }

  AuthMessage _authMessage = AuthMessage.empty();
  AuthMessage get authMessage => _authMessage;
  set authMessage(AuthMessage authMessage) {
    _authMessage = authMessage;
    notifyListeners();
  }

  int? _resendToken;
  String? _verificationId;
  String? get verificationId => _verificationId;
  set verificationId(String? verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  String _code = '';
  String get code => _code;
  set code(String code) {
    _code = code;
    if (code.length == 1) {
      authMessage = AuthMessage.empty();
    }
    notifyListeners();
  }

  late Stream<int> stream;

  Stream<int> get _stream =>
      Stream.periodic(Duration(seconds: 1), (v) => 30 - v);

  void sendOTP({
    required VoidCallback onComplete,
  }) async {
    loading2 = true;
    try {
      print('send Otp');
      await _auth.verifyPhoneNumber(
        forceResendingToken: _resendToken,
        phoneNumber: "+91" + newMobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading2 = true;
          await user.updatePhoneNumber(credential);
          _profileRepo.update(
            _profile.copyWith(mobile: "+91$newMobile"),
          );
          loading2 = false;
          onComplete();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print("The provided phone number is not valid.");
          }
          print('verification failed ${e.code}');
          loading2 = false;
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (_) {},
        codeSent: (String id, int? forceResendingToken) {
          verificationId = id;
          if (_resendToken != null) {
            authMessage = AuthMessage.otpResent();
          }
          _resendToken = forceResendingToken;
          stream = _stream;
          loading2 = false;
          print("Code sent");
        },
      );
    } catch (e) {
      print(e);
      loading2 = false;
    }
  }

  Future<void> verifyOTP(
      {required VoidCallback clear, required VoidCallback onVerify}) async {
    loading2 = true;
    try {
      print('Verify Otp');
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      await user.updatePhoneNumber(credential);
      print("Phone number updated");
      await _profileRepo.update(
        _profile.copyWith(mobile: "+91$newMobile"),
      );
      newMobile = '';
      verificationId = null;
      _resendToken = null;
      onVerify();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _authMessage = AuthMessage.incorrectOtp();
      } else {
        _authMessage = AuthMessage.error(e.message ?? '');
      }
      print("Verify Otp error: ${e.code}");
      clear();
    } catch (e) {
      print(e);
    }
    loading2 = false;
  }

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  void sendOtpToEmail() async {
    final int min = 100000; //min and max values act as your 6 digit range
    final int max = 999999;
    final randomizer = new Random();
    verificationId = '${min + randomizer.nextInt(max - min)}';
    try {
      final res = await _functions.httpsCallable('sendOtp').call({
        'name': _profile.firstName,
        'email': newEmail,
        'otp': verificationId,
      });
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  void verifyEmailOtp(
      {required VoidCallback clear, required VoidCallback onVerify}) async {
    if (code == verificationId) {
      loading2 = true;
      await _profileRepo.update(
        _profile.copyWith(emailAddress: newEmail),
      );
      onVerify();
      loading2 = false;
    } else {
      _authMessage = AuthMessage.incorrectOtp();
      clear();
    }
  }

  void clear() {
    _code = '';
    _verificationId = null;
    _resendToken = null;
  }
}
