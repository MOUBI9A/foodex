import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/features/location/providers/delivery_location_provider.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryMapPickerView extends ConsumerStatefulWidget {
  const DeliveryMapPickerView({super.key});

  @override
  ConsumerState<DeliveryMapPickerView> createState() =>
      _DeliveryMapPickerViewState();
}

class _DeliveryMapPickerViewState extends ConsumerState<DeliveryMapPickerView> {
  GoogleMapController? _mapController;
  LatLng? _cameraTarget;
  bool _isSaving = false;
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  static const LatLng _fallbackLatLng = LatLng(33.5731, -7.5898); // Casablanca

  @override
  void initState() {
    super.initState();
    final saved = ref.read(deliveryLocationProvider).location;
    _cameraTarget = saved != null
        ? LatLng(saved.latitude, saved.longitude)
        : _fallbackLatLng;
    _maybeCenterOnUser();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _maybeCenterOnUser() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition();
      _animateCamera(LatLng(position.latitude, position.longitude));
    } catch (_) {
      // ignore; fallback will be used
    }
  }

  void _onCameraMove(CameraPosition position) {
    _cameraTarget = position.target;
  }

  Future<void> _animateCamera(LatLng target) async {
    _cameraTarget = target;
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 15.5),
        ),
      );
    }
  }

  Future<void> _confirmSelection() async {
    if (_cameraTarget == null || _isSaving) return;
    setState(() => _isSaving = true);
    try {
      final l10n = AppLocalizations.of(context)!;
      await ref.read(deliveryLocationProvider.notifier).setManualLocation(
            latLng: _cameraTarget!,
            label: l10n.chooseOnMap,
          );
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final initialCamera =
        CameraPosition(target: _cameraTarget ?? _fallbackLatLng, zoom: 14);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryLocationTitle),
        backgroundColor: Colors.white,
        foregroundColor: TColor.primaryText,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCamera,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_controllerCompleter.isCompleted) {
                _controllerCompleter.complete(controller);
              }
            },
            onCameraMove: _onCameraMove,
          ),
          const Center(
            child: Icon(Icons.location_on, size: 36, color: Colors.redAccent),
          ),
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              heroTag: 'locate_me',
              backgroundColor: Colors.white,
              onPressed: _maybeCenterOnUser,
              child: Icon(Icons.my_location, color: TColor.primary),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _isSaving ? null : _confirmSelection,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                l10n.deliverHere,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
