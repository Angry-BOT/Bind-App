import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../repository/store_repository.dart';
import '../../../../utils/labels.dart';

final editUsernameViewModelProvider  = ChangeNotifierProvider((ref)=>EditUsernameViewModel(ref.read));

class EditUsernameViewModel extends ChangeNotifier {
  final Reader _reader;

  EditUsernameViewModel(this._reader);
  StoreRepository get _repository => _reader(storeRepositoryProvider);

  String? _username;
  String? get username => _username;
  set username(String? username) {
    _username = username;
    if (username != null && username.isNotEmpty) {
      _checkUserName(username);
    } else {
      _username = null;
    }
    notifyListeners();
  }

    String? validateUserName(String v) {
    if (v.toLowerCase() == _alreadyExistedUserName) {
      return Labels.usernameAlready;
    }
    return null;
  }

  String? _alreadyExistedUserName;

  void _checkUserName(String value) async {
    _alreadyExistedUserName =
        await _repository.getAlreadyExistedUsername(value.toLowerCase());
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> update(String id)async{
    loading = true;
    try {
      await _repository.updateUserName(id: id, name: username!);
      _loading = false;
    } catch (e) {
      loading = false;
      return Future.error(e);
    }
    
  }
}
