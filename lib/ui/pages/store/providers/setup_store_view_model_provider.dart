import 'dart:io';

import '../../../../model/profile.dart';
import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import '../../profile/providers/profile_provider.dart';
import 'admin_store_provider.dart';
import '../../../../utils/labels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final setupStoreViewModelProvider =
    ChangeNotifierProvider((ref) => SetupStoreViewModel(ref));

class SetupStoreViewModel extends ChangeNotifier {
  final Ref _ref;
  SetupStoreViewModel(this._ref);

  StoreRepository get _repository => _ref.read(storeRepositoryProvider);
  Profile get _profile => _ref.read(profileProvider).value!;

  Store get _store =>
      _ref.watch(adminStoreProvider).asData?.value ??
      Store.empty().copyWith(
        id: _profile.id,
        isVerified: _profile.isUdyogVerified,
        aadharVerified: _profile.aadharVerified,
        category: _profile.category,
        subCategories: _profile.subCategories,
        type: _profile.type!.length == 1
            ? describeEnum(_profile.type!.first)
            : _profile.type!
                .map(
                  (e) => describeEnum(e),
                )
                .join('/'),
      );

  String? get logo => _store.logo.isNotEmpty ? _store.logo : null;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String? _username;
  String get username => _username ?? _store.username;
  set username(String username) {
    _username = username;
    _checkUserName(username);
    notifyListeners();
  }

  String? validateUserName(String v) {
    if (v.toLowerCase() == _alreadyExistedUserName) {
      return Labels.usernameAlready;
    }
    return null;
  }

  String? _description;
  String get description => _description ?? _store.description;
  set description(String description) {
    _description = description;
    notifyListeners();
  }

  String? _name;
  String get name => _name ?? _store.name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  bool get isReady =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      (_file != null || logo != null);

  void writeStore({required VoidCallback onWrite}) async {
    final GeoPoint point = _profile.addresses
        .where((element) => element.name == Labels.store)
        .first
        .point;
    final store = _store.copyWith(
      username: username,
      name: name,
      description: description,
      point: GeoFirePoint(point.latitude, point.longitude),
      survicableRadius: _profile.survicableRadius,
    );
    try {
      loading = true;
      await _repository.writeStore(
        store: store,
        file: file,
      );
      onWrite();
      loading = false;
    } catch (e) {
      print(e);
    }
  }

  String? _alreadyExistedUserName;

  void _checkUserName(String value) async {
    _alreadyExistedUserName =
        await _repository.getAlreadyExistedUsername(value.toLowerCase());
  }
}
