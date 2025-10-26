import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/core/constants/routes.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/data/repositories/wallet_service.dart';

enum UserRole { customer, chef, courier, admin }

class UserTypeSelectorView extends StatefulWidget {
  const UserTypeSelectorView({super.key});

  @override
  State<UserTypeSelectorView> createState() => _UserTypeSelectorViewState();
}

class _UserTypeSelectorViewState extends State<UserTypeSelectorView> {
  UserRole? lastRole;
  bool loadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadLastRole();
  }

  Future<void> _loadLastRole() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('userRole');
    setState(() {
      lastRole = _decodeRole(raw);
      loadingPrefs = false;
    });
  }

  Future<void> _persistRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', _encodeRole(role));
  }

  String _encodeRole(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return 'customer';
      case UserRole.chef:
        return 'chef';
      case UserRole.courier:
        return 'courier';
      case UserRole.admin:
        return 'admin';
    }
  }

  UserRole? _decodeRole(String? raw) {
    switch (raw) {
      case 'customer':
        return UserRole.customer;
      case 'chef':
        return UserRole.chef;
      case 'courier':
        return UserRole.courier;
      case 'admin':
        return UserRole.admin;
    }
    return null;
  }

  Future<void> _handleSelection(UserRole role) async {
    await _persistRole(role);
    final walletService = WalletService();

    switch (role) {
      case UserRole.customer:
        await walletService.initializeWallet('customer_001');
        if (context.mounted) context.go(AppRouteNames.customerHome);
        break;
      case UserRole.chef:
        await walletService.initializeWallet('chef_001');
        if (context.mounted) context.go(AppRouteNames.chef);
        break;
      case UserRole.courier:
        await walletService.initializeWallet('courier_001');
        if (context.mounted) context.go(AppRouteNames.driver);
        break;
      case UserRole.admin:
        if (context.mounted) context.go(AppRouteNames.adminPanel);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width < 480 ? 20.0 : 32.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF7ED),
              const Color(0xFFFFE0B2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(isDark: isDark),
                      const SizedBox(height: 28),
                      _HeroTexts(isDark: isDark),
                      const SizedBox(height: 24),
                      if (!loadingPrefs && lastRole != null) ...[
                        _LastRoleBanner(
                          role: lastRole!,
                          isDark: isDark,
                          onTap: () => _handleSelection(lastRole!),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          height: 32,
                          thickness: 1,
                          color: Colors.black.withOpacity(0.05),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        'How would you like to use FoodEx?',
                        style: const TextStyle(
                          color: Color(0xFF6B5439),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _RoleCard(
                        icon: Icons.restaurant,
                        title: 'Customer',
                        subtitle: 'Browse & order homemade meals',
                        accent: const Color(0xFFFB6C2C),
                        background: const Color(0xFFFFFDFB),
                        onTap: () => _handleSelection(UserRole.customer),
                      ),
                      const SizedBox(height: 12),
                      _RoleCard(
                        icon: Icons.local_dining,
                        title: 'Home Chef',
                        subtitle: 'Share your culinary passion & earn',
                        accent: const Color(0xFF4CAF50),
                        background: const Color(0xFFE8F5E9),
                        onTap: () => _handleSelection(UserRole.chef),
                      ),
                      const SizedBox(height: 12),
                      _RoleCard(
                        icon: Icons.delivery_dining,
                        title: 'Courier',
                        subtitle: 'Deliver meals & earn money',
                        accent: const Color(0xFFFFC107),
                        background: const Color(0xFFFFF8E1),
                        onTap: () => _handleSelection(UserRole.courier),
                      ),
                      const SizedBox(height: 12),
                      _RoleCard(
                        icon: Icons.admin_panel_settings,
                        title: 'Admin',
                        subtitle: 'Manage platform & view analytics',
                        accent: const Color(0xFF8E24AA),
                        background: const Color(0xFFF3E5F5),
                        onTap: () => _handleSelection(UserRole.admin),
                      ),
                      const SizedBox(height: 24),
                      _Footer(isDark: isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 28,
                color: TColor.primary,
              ),
              const SizedBox(height: 4),
              Text(
                'FoodEx',
                style: TextStyle(
                  color: TColor.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.help_outline, size: 18),
          label: const Text('Help'),
          style: TextButton.styleFrom(
            foregroundColor:
                isDark ? Colors.white70 : const Color(0xFF5F4B32),
          ),
        ),
      ],
    );
  }
}

class _HeroTexts extends StatelessWidget {
  final bool isDark;
  const _HeroTexts({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your local home-chef marketplace',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF3B2A16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Eat fresh. Support local. Feel home.',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white70 : const Color(0xFF6B5439),
          ),
        ),
      ],
    );
  }
}

class _LastRoleBanner extends StatelessWidget {
  final UserRole role;
  final bool isDark;
  final VoidCallback onTap;
  const _LastRoleBanner({
    required this.role,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isDark ? 0.08 : 0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: TColor.primary.withOpacity(0.1),
              child: Icon(
                _roleIcon(role),
                color: TColor.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Continue as ${_roleLabel(role)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B2A16),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to jump back in',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const _ArrowPill(),
          ],
        ),
      ),
    );
  }

  IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return Icons.restaurant;
      case UserRole.chef:
        return Icons.local_dining;
      case UserRole.courier:
        return Icons.delivery_dining;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.chef:
        return 'Home Chef';
      case UserRole.courier:
        return 'Courier';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color background;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.background,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool hovering = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = pressed ? 0.98 : (hovering ? 1.02 : 1.0);
    final shadowOpacity = pressed
        ? 0.05
        : hovering
            ? 0.16
            : 0.08;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() {
        hovering = false;
        pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapCancel: () => setState(() => pressed = false),
        onTapUp: (_) {
          setState(() => pressed = false);
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(shadowOpacity),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.background,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.accent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C1E10),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B5439),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const _ArrowPill(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowPill extends StatelessWidget {
  const _ArrowPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.arrow_forward_rounded, size: 18),
    );
  }
}

class _SurfaceCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SurfaceCard({required this.child, required this.onTap});

  @override
  State<_SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<_SurfaceCard> {
  bool hovering = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = pressed ? 0.98 : (hovering ? 1.01 : 1.0);
    final shadowOpacity = pressed
        ? 0.04
        : hovering
            ? 0.12
            : 0.06;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() {
        hovering = false;
        pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapCancel: () => setState(() => pressed = false),
        onTapUp: (_) {
          setState(() => pressed = false);
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(shadowOpacity),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isDark;
  const _Footer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.white70 : const Color(0xFF6B5439);
    return Column(
      children: [
        Text(
          'Already a member?',
          style: TextStyle(color: color),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Sign in',
            style: TextStyle(
              color: Color(0xFFFB6C2C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'English / Français',
            style: TextStyle(color: color),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
