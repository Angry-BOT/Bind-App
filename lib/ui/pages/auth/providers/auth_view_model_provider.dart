import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/auth_message.dart';

final authViewModelProvider =
    ChangeNotifierProvider<AuthViewModel>((ref) => AuthViewModel());

class AuthViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String? _verificationId;

  String? get verificationId => _verificationId;
  set verificationId(String? verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String phone) {
    _phone = phone;
    _resendToken = null;
    notifyListeners();
  }

  AuthMessage _authMessage = AuthMessage.empty();

  AuthMessage get authMessage => _authMessage;

  set authMessage(AuthMessage authMessage) {
    _authMessage = authMessage;
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

  int? _resendToken;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  late Stream<int> stream;

  Stream<int> get _stream =>
      Stream.periodic(Duration(seconds: 1), (v) => 30 - v);

  void sendOTP({
    required VoidCallback onSend,
    required VoidCallback onComplete,
  }) async {
    loading = true;
    try {
      await _auth.verifyPhoneNumber(
        forceResendingToken: _resendToken,
        phoneNumber: "+91" + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('Done');
          loading = true;
          user = (await _auth.signInWithCredential(credential)).user;
          loading = false;
          _verificationId = null;
          onComplete();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(
                msg: "The provided phone number is not valid.");
          } else {
            Fluttertoast.showToast(msg: e.code);
          }
          loading = false;
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
          loading = false;
          onSend();
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "$e");
      loading = false;
    }
  }

  Future<void> verifyOTP(
      {required VoidCallback clear, required VoidCallback onVerify}) async {
    loading = true;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      user = (await _auth.signInWithCredential(credential)).user;
      phone = '';
      _verificationId = null;
      onVerify();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _authMessage = AuthMessage.incorrectOtp();
      } else {
        _authMessage = AuthMessage.error(e.message ?? '');
      }
      clear();
    } catch (e) {
      print(e);
    }
    loading = false;
  }

  Future<void> signOut({required VoidCallback onDone}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(user!.uid)
          .update({Constants.token: FieldValue.delete()});
      await _auth.signOut();
      user = null;
      onDone();
      await Future.delayed(Duration(seconds: 2));
      final _messaging = FirebaseMessaging.instance;
      _messaging.unsubscribeFromTopic('posts');
      try {
        _messaging.unsubscribeFromTopic('offers');
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  void update() async {
    if (_auth.currentUser == null) {
      user!.reload();
    } else {
      _auth.currentUser!.reload();
      user = _auth.currentUser;
    }
    notifyListeners();
  }
}
