import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constants.dart';

import '../model/search_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../model/address.dart';

final geoReposioryProvider = Provider<GeoRepository>((ref) => GeoRepository());

class GeoRepository {
  final String _key = "AIzaSyA2KwctHOaF0styLEowjV9cZMJf_gxaC2g";

  GoogleMapsGeocoding get geocoding => new GoogleMapsGeocoding(apiKey: _key);

  Future<Address> getAddress(LatLng point) async {
    final GeocodingResponse response = await geocoding
        .searchByLocation(Location(lat: point.latitude, lng: point.longitude));
    print(response.results.length);

    if (response.errorMessage != null) {
      print(response.errorMessage);
      return Address.empty();
    } else {
      final GeocodingResult result = response.results.first;
      print(result.addressComponents.map((e) => e.toJson()).toList());
      final list = result.addressComponents
          .where((element) => element.types.contains(Constants.locality));
      final list2 = result.addressComponents
          .where((element) => element.types.contains(Constants.stateKey));
      return Address.empty().copyWith(
        formated: result.formattedAddress,
        location: result.addressComponents[2].shortName,
        point: GeoPoint(point.latitude, point.longitude),
        city: list.isNotEmpty
            ? list.last.shortName
            : result.addressComponents[1].shortName,
        state: list2.isNotEmpty
            ? list2.last.longName
            : result.addressComponents[1].longName,
      );
    }
  }

  Future<Address> getAddressById(String id) async {
    final places = new GoogleMapsPlaces(apiKey: _key);
    final PlacesDetailsResponse response = await places.getDetailsByPlaceId(id);
    if (response.errorMessage != null) {
      print(response.errorMessage);
      return Address.empty();
    } else {
      final PlaceDetails result = response.result;
      final list = result.addressComponents
          .where((element) => element.types.contains(Constants.locality));
      final list2 = result.addressComponents
          .where((element) => element.types.contains(Constants.stateKey));
      return Address.empty().copyWith(
        formated: result.formattedAddress,
        location: result.addressComponents[0].shortName,
        city: list.isNotEmpty
            ? list.last.shortName
            : result.addressComponents[1].shortName,
        point: GeoPoint(
          result.geometry!.location.lat,
          result.geometry!.location.lng,
        ),
        state: list2.isNotEmpty
            ? list2.last.longName
            : result.addressComponents[1].longName,
      );
    }
  }

  Future<List<SearchResult>> getSearchResults(String key) async {
    final String _key = "AIzaSyA2KwctHOaF0styLEowjV9cZMJf_gxaC2g";
    final places = new GoogleMapsPlaces(apiKey: _key);
    final PlacesAutocompleteResponse response =
        await places.autocomplete(key, region: 'in');
    if (response.errorMessage != null) {
      return Future.error(response.errorMessage.toString());
    }
    return response.predictions
        .where((element) => element.placeId != null)
        .map(
          (e) => SearchResult(
            id: e.placeId!,
            subtitle: e.structuredFormatting?.secondaryText ?? '',
            title: e.structuredFormatting?.mainText ?? '',
            
          ),
        )
        .toList();
  }

  Future<geo.Position?> determinePosition({bool? enabled}) async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = enabled?? await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return null;
      }
    }
    if (permission == geo.LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Location permissions are permanently denied");
      return null;
    }
    return await geo.Geolocator.getCurrentPosition();
  }
}
