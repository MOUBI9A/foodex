import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/profile/models/user_profile.dart';

/// Placeholder user profile provider until backend wiring is ready.
class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(const UserProfile(
          name: 'Salma Ben Ali',
          email: 'salma@example.com',
          phone: '+212 6 44 11 22 33',
          avatarUrl: null,
        ));

  void update(UserProfile profile) => state = profile;
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

/// Unread notifications counter placeholder.
final unreadNotificationsProvider = StateProvider<int>((ref) => 3);

class ActiveOrderStatus {
  final bool hasActiveOrder;
  final String statusLabel;

  const ActiveOrderStatus(
      {required this.hasActiveOrder, required this.statusLabel});
}

final activeOrderStatusProvider = Provider<ActiveOrderStatus>((ref) {
  return const ActiveOrderStatus(
    hasActiveOrder: true,
    statusLabel: 'Driver en route • 8 min',
  );
});
