// import '../providers/pref_provider.dart';
import '../providers/pref_provider.dart';
import '../utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localRepositoryProvider =
    Provider<LocalRepository>((ref) => LocalRepository(ref));

class LocalRepository {
  final Ref _ref;
  LocalRepository(this._ref);

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SharedPreferences get _pref => _ref.read(prefProvider).value!;

  bool readSeen()  {
    return _pref.getBool(Constants.seen) ?? false;
  }

  void saveSeen() async {
    _pref.setBool(Constants.seen, true);
  }
}
