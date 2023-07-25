import '../../../../model/address.dart';
import '../../../../model/profile.dart';
import '../../../../repository/geo_repository.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  ref.watch(profileProvider.select((value) => value.value!.id));
  ref.watch(profileProvider.select((value) => value.value!.addresses.isNotEmpty));
  final model = HomeViewModel(ref);
  model.initialize();
  return model;
});

class HomeViewModel extends ChangeNotifier {
  final Ref _ref;
  HomeViewModel(this._ref);

  Address? _address;
  Address? get address => _address;
  set address(Address? address) {
    _address = address;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  bool _showBanner = true;
  bool get showBanner => _showBanner;
  set showBanner(bool showBanner) {
    _showBanner = showBanner;
    notifyListeners();
  }

  Profile get _profile => _ref.read(profileProvider).value!;

  void initialize() async {
    if (_profile.addresses.length == 1) {
      _address = _profile.addresses.first;
    } else {
      loading = true;
      try {
        final value = await _ref.read(geoReposioryProvider).determinePosition();
        if (value != null) {
          _profile.addresses.sort((a, b) {
            return Geolocator.distanceBetween(value.latitude, value.longitude,
                    a.point.latitude, a.point.longitude)
                .compareTo(
              Geolocator.distanceBetween(value.latitude, value.longitude,
                  b.point.latitude, b.point.longitude),
            );
          });
        }
      } catch (e) {
        print(e);
      }
      address = _profile.addresses.first;
      loading = false;
    }
  }
}
