import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/services/delivery_location_storage.dart';
import 'package:food_delivery/data/models/delivery_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryLocationState {
  final DeliveryLocation? location;
  final bool isLoading;
  final String? errorMessage;

  const DeliveryLocationState({
    this.location,
    this.isLoading = false,
    this.errorMessage,
  });

  DeliveryLocationState copyWith({
    DeliveryLocation? location,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DeliveryLocationState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class DeliveryLocationNotifier extends StateNotifier<DeliveryLocationState> {
  DeliveryLocationNotifier(this._storage)
      : super(const DeliveryLocationState()) {
    _loadInitial();
  }

  final DeliveryLocationStorage _storage;

  Future<void> _loadInitial() async {
    final savedLocation = await _storage.load();
    if (savedLocation != null) {
      state = state.copyWith(location: savedLocation);
    }
  }

  Future<void> setLiveLocation({String label = 'Current Location'}) async {
    await _updateLocation(() async {
      final permission = await _ensurePermission();
      if (permission == LocationPermission.deniedForever) {
        throw const LocationServiceDisabledException(
            'Location permission permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final address =
          await _reverseGeocode(position.latitude, position.longitude);
      return DeliveryLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        label: label,
        formattedAddress: address,
        isLiveLocation: true,
        updatedAt: DateTime.now(),
      );
    });
  }

  Future<void> setManualLocation({
    required LatLng latLng,
    String label = 'Selected Location',
    String? formattedAddress,
  }) async {
    await _updateLocation(() async {
      final address = formattedAddress ??
          await _reverseGeocode(latLng.latitude, latLng.longitude);
      return DeliveryLocation(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        label: label,
        formattedAddress: address,
        isLiveLocation: false,
        updatedAt: DateTime.now(),
      );
    });
  }

  Future<void> _updateLocation(
    Future<DeliveryLocation> Function() builder,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final location = await builder();
      await _storage.save(location);
      state = state.copyWith(location: location, isLoading: false);
    } catch (e) {
      debugPrint('Delivery location error: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<String> _reverseGeocode(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return 'Unnamed location';
      final place = placemarks.first;
      final segments = [
        place.street,
        place.subLocality,
        place.locality,
        place.country,
      ].where((segment) => segment != null && segment!.isNotEmpty).toList();
      return segments.map((e) => e!).join(', ');
    } catch (_) {
      return 'Unnamed location';
    }
  }

  Future<LocationPermission> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException(
          'Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }
}

final deliveryLocationProvider =
    StateNotifierProvider<DeliveryLocationNotifier, DeliveryLocationState>(
        (ref) {
  return DeliveryLocationNotifier(const DeliveryLocationStorage());
});
