import 'package:android_intent/android_intent.dart';
import 'package:bind_app/ui/pages/auth/providers/add_documents_view_model_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/address.dart';
import '../../../../repository/geo_repository.dart';
import '../../../../repository/profile_repository.dart';
import '../../../../utils/labels.dart';

final writeAddressViewModelProvider =
    ChangeNotifierProvider((ref) => WriteAddressModel(ref));

class WriteAddressModel extends ChangeNotifier {
  final Ref _ref;
  WriteAddressModel(this._ref);

  GoogleMapController? mapController;

  ProfileRepository get _profileRepo => _ref.read(profileRepositoryProvider);
  GeoRepository get _geo => _ref.read(geoReposioryProvider);

  bool needStoreAddress = false;
  bool homeAddressExists = false;

  Address? deletableAddress;

  LatLng _latLng = LatLng(18.5204, 73.8567);
  LatLng get latLng => _latLng;

  set latLng(LatLng v) {
    _latLng = v;
    notifyListeners();
    try {
      _geo.getAddress(v).then((value) {
        address = value;
      });
    } catch (e) {
      print(e);
    }
  }

  LatLng? _markerPosition;
  set markerPosition(LatLng? markerPosition) {
    _markerPosition = markerPosition;
    latLng = markerPosition!;
    notifyListeners();
  }

  Set<Marker> get markers => _markerPosition != null
      ? {
          Marker(
            draggable: true,
            markerId: MarkerId('Marker'),
            position:
                LatLng(_markerPosition!.latitude, _markerPosition!.longitude),
            onDragEnd: ((newPosition) {
              latLng = newPosition;
              markerPosition = newPosition;
            }),
          )
        }
      : {};

  String _number = '';
  String get number => _number.isNotEmpty ? _number : address?.number ?? '';
  set number(String number) {
    _number = number;
    notifyListeners();
  }

  String _landmark = '';
  String get landmark =>
      _landmark.isNotEmpty ? _landmark : address?.landmark ?? '';
  set landmark(String landmark) {
    _landmark = landmark;
    notifyListeners();
  }

  bool? _other;
  bool get other => _other ?? (homeAddressExists ? true : false);
  set other(bool other) {
    _other = other;
    if (other) {
      _type = '';
    }
    notifyListeners();
  }

  String? _type;
  String get type => _type ?? (homeAddressExists ? '' : Labels.home);
  set type(String type) {
    _type = type;
    if (type != Labels.home && type != Labels.store) {
      _other = true;
    } else if (type == Labels.home) {
      _other = null;
    }
    notifyListeners();
  }

  bool get isReady =>
      number.isNotEmpty &&
      landmark.isNotEmpty &&
      type.isNotEmpty &&
      type != Labels.other;

  Address? _address;
  Address? get address => _address;
  set address(Address? address) {
    _address = address;
    if (address != null) {
      _latLng = LatLng(address.point.latitude, address.point.longitude);
      _markerPosition = _latLng;
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    } else {
      _markerPosition = null;
    }
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> addAddress({required VoidCallback onDone}) async {
    loading = true;
    try {
      if (needStoreAddress) {
        final updated = address!.copyWith(
          name: Labels.store,
          landmark: landmark,
          number: number,
        );
        await _ref
            .read(addDocumentsViewModelProvider)
            .completeProfile(onComplete: onDone, address: updated);
      } else {
        await _profileRepo.addAddress(
          address!.copyWith(
            number: number,
            landmark: landmark,
            name: type,
          ),
        );
        if(deletableAddress!=null){
          await _profileRepo.deleteAddress(deletableAddress!);
          deletableAddress = null;
        }
        onDone();
      }
      _type = null;
      _loading = false;
    } catch (e) {
      loading = false;
    }
  }

  void handleLocateMe(bool enabled) async {
    if (enabled) {
      final Position? position = await _ref
          .read(geoReposioryProvider)
          .determinePosition(enabled: enabled);
      if (position != null) {
        latLng = LatLng(position.latitude, position.longitude);
        markerPosition = latLng;
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(latLng),
          );
        }
      }
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final intent = AndroidIntent(
          action: 'android.settings.LOCATION_SOURCE_SETTINGS',
        );
        await intent.launch();
      } else {
        //TODO
      }
    }
  }

  void clear() {
    homeAddressExists = false;
    _type = null;
    _other = null;
  }
}
