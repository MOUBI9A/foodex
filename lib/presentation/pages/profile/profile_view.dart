import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/constants/routes.dart';
import 'package:food_delivery/core/network/service_call.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/features/location/providers/delivery_location_provider.dart';
import 'package:food_delivery/features/profile/providers/profile_providers.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';
import 'package:food_delivery/presentation/pages/login/login_view.dart';
import 'package:food_delivery/presentation/pages/more/about_us_view.dart';
import 'package:food_delivery/presentation/pages/more/inbox_view.dart';
import 'package:food_delivery/presentation/pages/more/my_order_view.dart';
import 'package:food_delivery/presentation/pages/more/notification_view.dart';
import 'package:food_delivery/presentation/pages/more/payment_details_view.dart';
import 'package:food_delivery/presentation/pages/profile/edit_profile_view.dart';
import 'package:food_delivery/presentation/pages/profile/support_faq_view.dart';
import 'package:food_delivery/presentation/pages/wallet/wallet_view.dart';
import 'package:food_delivery/presentation/widgets/delivery_location_sheet.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProfileProvider);
    final locationState = ref.watch(deliveryLocationProvider);
    final activeOrder = ref.watch(activeOrderStatusProvider);
    final unreadCount = ref.watch(unreadNotificationsProvider);

    final locationLabel =
        locationState.location?.label ?? l10n.useCurrentLocation;
    final locationAddress =
        (locationState.location?.formattedAddress ?? '').isNotEmpty
            ? locationState.location!.formattedAddress
            : l10n.useCurrentSubtitle;

    final sections = _buildSections(
      context: context,
      unreadCount: unreadCount,
      activeOrder: activeOrder,
    );

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(
                context: context,
                userName: user.name,
                userContact: user.phone.isNotEmpty ? user.phone : user.email,
                avatarUrl: user.avatarUrl,
                locationLabel: locationLabel,
                locationAddress: locationAddress,
              ),
              const SizedBox(height: 24),
              ...sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _ProfileSectionCard(section: section),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard({
    required BuildContext context,
    required String userName,
    required String userContact,
    required String locationLabel,
    required String locationAddress,
    String? avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColor.primary, TColor.primary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white24,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null
                    ? Text(
                        userName.isNotEmpty ? userName.substring(0, 1) : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userContact,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileView()),
                  );
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.place_outlined, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivering to: $locationLabel',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        locationAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withOpacity(0.85)),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _openLocationSheet,
                  child: const Text(
                    'Change',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_ProfileSection> _buildSections({
    required BuildContext context,
    required int unreadCount,
    required ActiveOrderStatus activeOrder,
  }) {
    return [
      _ProfileSection(
        title: 'My Activity',
        items: [
          _ProfileTileData(
            icon: Icons.receipt_long,
            color: Colors.deepOrange,
            title: 'My Orders',
            subtitle: 'Track your past and active orders',
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const MyOrderView()),
            ),
          ),
          _ProfileTileData(
            icon: Icons.delivery_dining,
            color: Colors.green,
            title: 'Suivi en direct',
            subtitle: activeOrder.hasActiveOrder
                ? activeOrder.statusLabel
                : 'No delivery in progress',
            enabled: activeOrder.hasActiveOrder,
            onTap: (ctx) {
              if (activeOrder.hasActiveOrder) {
                ctx.push(AppRouteNames.customerOrderTracking);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('No live delivery right now.')),
                );
              }
            },
          ),
        ],
      ),
      _ProfileSection(
        title: 'Wallet & Payment',
        items: [
          _ProfileTileData(
            icon: Icons.account_balance_wallet,
            color: Colors.teal,
            title: 'My Wallet',
            subtitle: 'Balance, credits, promo codes',
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const WalletView()),
            ),
          ),
          _ProfileTileData(
            icon: Icons.credit_card,
            color: TColor.primary,
            title: 'Payment Details',
            subtitle: 'Saved cards and payment methods',
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const PaymentDetailsView()),
            ),
          ),
        ],
      ),
      _ProfileSection(
        title: 'Communication',
        items: [
          _ProfileTileData(
            icon: Icons.notifications_active,
            color: Colors.redAccent,
            title: 'Notifications',
            subtitle: 'Updates about your orders',
            badgeCount: unreadCount > 0 ? unreadCount : null,
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const NotificationsView()),
            ),
          ),
          _ProfileTileData(
            icon: Icons.mail_outline,
            color: Colors.blueAccent,
            title: 'Inbox',
            subtitle: 'Messages from chefs / support',
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const InboxView()),
            ),
          ),
        ],
      ),
      _ProfileSection(
        title: 'Taste & Personalization',
        items: [
          _ProfileTileData(
            icon: Icons.restaurant,
            color: Colors.purple,
            title: 'Taste Profile',
            subtitle: 'Your dislikes, allergies, preferences',
            onTap: (ctx) => ctx.push(AppRouteNames.customerTasteProfile),
          ),
          _ProfileTileData(
            icon: Icons.star_rate,
            color: Colors.amber.shade700,
            title: 'Recommendations',
            subtitle: 'Suggested dishes and chefs for you',
            onTap: (ctx) => ctx.push(AppRouteNames.customerRecommendations),
          ),
        ],
      ),
      _ProfileSection(
        title: 'App & Account',
        items: [
          _ProfileTileData(
            icon: Icons.info_outline,
            color: Colors.indigo,
            title: 'About Us',
            subtitle: 'Who we are',
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const AboutUsView()),
            ),
          ),
          _ProfileTileData(
            icon: Icons.help_outline,
            color: Colors.cyan,
            title: 'Help / Support / FAQ',
            subtitle: 'Get help, report an issue',
            onTap: (ctx) => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SupportFaqView()),
            ),
          ),
          _ProfileTileData(
            icon: Icons.logout,
            color: TColor.error,
            title: 'Sign out',
            subtitle: 'Return to login',
            isDanger: true,
            onTap: (ctx) {
              ServiceCall.logout();
              Navigator.pushAndRemoveUntil(
                ctx,
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    ];
  }

  Future<void> _openLocationSheet() async {
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: const DeliveryLocationSheet(),
        );
      },
    );
  }
}

class _ProfileSection {
  final String title;
  final List<_ProfileTileData> items;

  const _ProfileSection({required this.title, required this.items});
}

class _ProfileTileData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final void Function(BuildContext) onTap;
  final int? badgeCount;
  final bool enabled;
  final bool isDanger;

  const _ProfileTileData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeCount,
    this.enabled = true,
    this.isDanger = false,
  });
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({required this.section});

  final _ProfileSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: TColor.cardShadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Text(
              section.title,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(height: 1),
          ...section.items.map(
            (item) => _ProfileTile(item: item),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.item});

  final _ProfileTileData item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.enabled ? () => item.onTap(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: item.isDanger
                                ? TColor.error
                                : TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (item.badgeCount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: TColor.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.badgeCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: item.enabled
                            ? TColor.secondaryText
                            : TColor.secondaryText.withOpacity(0.4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: item.enabled
                          ? TColor.secondaryText
                          : TColor.secondaryText.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
