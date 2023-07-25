import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _locationStatusProvider = StreamProvider<ServiceStatus>(
  (ref) {
    return Geolocator.getServiceStatusStream();
  },
);

final locationStatusProvider = FutureProvider<bool>(
  (ref) async {
    final statusData = ref.watch(_locationStatusProvider).data;
    if (statusData != null) {
      return Future.value(statusData.value == ServiceStatus.enabled);
    } else {
      return await Geolocator.isLocationServiceEnabled();
    }
  },
);