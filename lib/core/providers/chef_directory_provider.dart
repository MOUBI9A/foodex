import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chef_profile.dart';

final chefDirectoryProvider = Provider<Map<String, ChefProfile>>((ref) {
  return {
    'chef_001': const ChefProfile(
      id: 'chef_001',
      name: 'Chef Salma',
      kitchenName: 'Dar Salma',
      lat: 33.5899,
      lng: -7.6039,
    ),
    'chef_002': const ChefProfile(
      id: 'chef_002',
      name: 'Chef Mehdi',
      kitchenName: 'Atelier Mehdi',
      lat: 33.5731,
      lng: -7.5898,
    ),
    'chef_003': const ChefProfile(
      id: 'chef_003',
      name: 'Chef Amina',
      kitchenName: 'Maison Amina',
      lat: 33.6001,
      lng: -7.6204,
    ),
  };
});
