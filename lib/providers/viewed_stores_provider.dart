import 'package:bind_app/providers/pref_provider.dart';
import 'package:bind_app/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final viewdStoresProvider = Provider<List<String>>((ref) =>
    ref.watch(prefProvider).value!.getStringList(Constants.stores) ?? []);
