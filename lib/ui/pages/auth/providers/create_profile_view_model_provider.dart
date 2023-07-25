import 'package:firebase_auth/firebase_auth.dart';

import '../../../../enums/status.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/profile.dart';
import '../../../../repository/profile_repository.dart';

final createProfileViewModelProvider =
    ChangeNotifierProvider((ref) => CreateProfileViewModel(ref));

class CreateProfileViewModel extends ChangeNotifier {
  final Ref _ref;
  CreateProfileViewModel(this._ref);

  ProfileRepository get _profileRepo => _ref.read(profileRepositoryProvider);

  Profile? profile;




  String? _firstName;
  String get firstName => _firstName ?? profile?.firstName ?? "";
  set firstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  String? _lastName;
  String get lastName => _lastName ?? profile?.lastName ?? '';
  set lastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  String? _emailAddress;
  String get emailAddress => _emailAddress ?? profile?.emailAddress ?? "";
  set emailAddress(String emailAddress) {
    _emailAddress = emailAddress;
    _checkEmail(emailAddress);
    notifyListeners();
  }

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

  bool get isReady =>
      firstName.isNotEmpty && lastName.isNotEmpty && emailAddress.isNotEmpty;

  Future<void> createProfile({required VoidCallback onCreate}) async {
    try {
      onCreate();
      await _profileRepo.createProfile(
        Profile(
          mobile: '',
          firstName: firstName,
          lastName: lastName,
          emailAddress: emailAddress,
          isEntrepreneur: false,
          status: Status.Active,
          favorites: [],
          likes: [],
          bookmarks: [],
          isEmailVerified: false,
        ),
      );
      _lastName = null;
      _firstName = null;
      _emailAddress = null;
      profile = null;
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  final List<String> _endings = ['.com', '.net', '.org', '.in', '.co'];
  String? _alreadyExistedEmail;

  void _checkEmail(String value) async {
    for (var item in _endings) {
      if (value.endsWith(item)) {
        _alreadyExistedEmail = await _profileRepo.getAlreadyExistedEmail(value);
      }
    }
  }
}
