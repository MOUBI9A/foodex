import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin Settings Page
///
/// Platform configuration and settings management.
/// Allows administrators to configure global platform settings.
///
/// Features:
/// - General settings (app name, description, contact info)
/// - Commission rates (platform fee, chef commission, delivery fee)
/// - Payment gateway configuration (Stripe, PayPal)
/// - Email/SMS notification settings
/// - Security settings (2FA, password policy, session timeout)
/// - Feature toggles (enable/disable features)
/// - Backup and restore settings
/// - API key management
/// - System maintenance mode
///
/// Layout:
/// ┌────────────────────────────────────────┐
/// │ Settings (title)                       │
/// ├──────────┬─────────────────────────────┤
/// │          │                             │
/// │ Sidebar  │   Settings Content          │
/// │ - General│   (Selected Category)       │
/// │ - Payment│                             │
/// │ - Notifs │                             │
/// │ - Security                             │
/// │ - Features                             │
/// │ - System │                             │
/// │          │                             │
/// └──────────┴─────────────────────────────┘
///
/// State Management:
/// - Settings data (Riverpod AsyncValue)
/// - Form state (local)
/// - Unsaved changes tracking
///
/// API Integration:
/// - GET /api/admin/settings
/// - PUT /api/admin/settings/:category
class AdminSettingsPage extends ConsumerStatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  ConsumerState<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends ConsumerState<AdminSettingsPage> {
  // Selected category
  String _selectedCategory = 'general';

  // Form state
  bool _hasUnsavedChanges = false;

  // General settings
  final _appNameController = TextEditingController(text: 'FoodEx');
  final _appDescriptionController = TextEditingController(
    text: 'Decentralized Food Delivery Platform',
  );
  final _supportEmailController =
      TextEditingController(text: 'support@foodex.com');

  // Commission settings
  double _platformCommission = 15.0;
  double _chefCommission = 70.0;
  double _deliveryCommission = 15.0;

  // Feature toggles
  bool _enableChefRegistration = true;
  bool _enableDeliveryRegistration = true;
  bool _enableGuestCheckout = false;
  bool _enableReviews = true;
  bool _enableLiveTracking = true;

  // Security settings
  bool _require2FA = false;
  int _sessionTimeout = 30; // minutes
  int _minPasswordLength = 8;

  // System settings
  bool _maintenanceMode = false;

  @override
  void dispose() {
    _appNameController.dispose();
    _appDescriptionController.dispose();
    _supportEmailController.dispose();
    super.dispose();
  }

  /// Mark form as changed
  void _markChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  /// Save settings
  Future<void> _saveSettings() async {
    // TODO: Validate and save settings to API
    // await ref.read(adminSettingsProvider.notifier).saveSettings(...);

    setState(() {
      _hasUnsavedChanges = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully')),
      );
    }
  }

  /// Reset to defaults
  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
            'Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Reset settings
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildCategoryTile('general', 'General', Icons.settings),
                _buildCategoryTile(
                    'payment', 'Payment & Commission', Icons.payment),
                _buildCategoryTile(
                    'notifications', 'Notifications', Icons.notifications),
                _buildCategoryTile('security', 'Security', Icons.security),
                _buildCategoryTile('features', 'Features', Icons.toggle_on),
                _buildCategoryTile('system', 'System', Icons.computer),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Column(
              children: [
                // Header with save button
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.dividerColor),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getCategoryTitle(_selectedCategory),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: _resetToDefaults,
                            child: const Text('Reset to Defaults'),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            onPressed:
                                _hasUnsavedChanges ? _saveSettings : null,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Changes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Settings content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildSettingsContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build category list tile
  Widget _buildCategoryTile(String category, String title, IconData icon) {
    final isSelected = _selectedCategory == category;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  /// Get category display title
  String _getCategoryTitle(String category) {
    switch (category) {
      case 'general':
        return 'General Settings';
      case 'payment':
        return 'Payment & Commission';
      case 'notifications':
        return 'Notification Settings';
      case 'security':
        return 'Security Settings';
      case 'features':
        return 'Feature Toggles';
      case 'system':
        return 'System Settings';
      default:
        return 'Settings';
    }
  }

  /// Build settings content based on selected category
  Widget _buildSettingsContent() {
    switch (_selectedCategory) {
      case 'general':
        return _buildGeneralSettings();
      case 'payment':
        return _buildPaymentSettings();
      case 'notifications':
        return _buildNotificationSettings();
      case 'security':
        return _buildSecuritySettings();
      case 'features':
        return _buildFeatureSettings();
      case 'system':
        return _buildSystemSettings();
      default:
        return const SizedBox();
    }
  }

  /// Build general settings
  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _appNameController,
          decoration: const InputDecoration(
            labelText: 'Application Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _markChanged(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _appDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Application Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => _markChanged(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _supportEmailController,
          decoration: const InputDecoration(
            labelText: 'Support Email',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _markChanged(),
        ),
      ],
    );
  }

  /// Build payment settings
  Widget _buildPaymentSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Commission Rates',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSlider(
          'Platform Commission',
          _platformCommission,
          (value) {
            setState(() {
              _platformCommission = value;
              _markChanged();
            });
          },
        ),
        const SizedBox(height: 16),
        _buildSlider(
          'Chef Commission',
          _chefCommission,
          (value) {
            setState(() {
              _chefCommission = value;
              _markChanged();
            });
          },
        ),
        const SizedBox(height: 16),
        _buildSlider(
          'Delivery Commission',
          _deliveryCommission,
          (value) {
            setState(() {
              _deliveryCommission = value;
              _markChanged();
            });
          },
        ),
      ],
    );
  }

  /// Build notification settings
  Widget _buildNotificationSettings() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email and SMS notification settings will be configured here.'),
        SizedBox(height: 16),
        Text('TODO: Add email templates, SMS gateway configuration, etc.'),
      ],
    );
  }

  /// Build security settings
  Widget _buildSecuritySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Require Two-Factor Authentication'),
          subtitle: const Text('Force all users to enable 2FA'),
          value: _require2FA,
          onChanged: (value) {
            setState(() {
              _require2FA = value;
              _markChanged();
            });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Session Timeout (minutes)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: '$_sessionTimeout'),
          onChanged: (value) {
            final intValue = int.tryParse(value);
            if (intValue != null) {
              _sessionTimeout = intValue;
              _markChanged();
            }
          },
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Minimum Password Length',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: '$_minPasswordLength'),
          onChanged: (value) {
            final intValue = int.tryParse(value);
            if (intValue != null) {
              _minPasswordLength = intValue;
              _markChanged();
            }
          },
        ),
      ],
    );
  }

  /// Build feature toggles
  Widget _buildFeatureSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Chef Registration'),
          subtitle: const Text('Allow new chefs to register'),
          value: _enableChefRegistration,
          onChanged: (value) {
            setState(() {
              _enableChefRegistration = value;
              _markChanged();
            });
          },
        ),
        SwitchListTile(
          title: const Text('Delivery Registration'),
          subtitle: const Text('Allow new delivery personnel to register'),
          value: _enableDeliveryRegistration,
          onChanged: (value) {
            setState(() {
              _enableDeliveryRegistration = value;
              _markChanged();
            });
          },
        ),
        SwitchListTile(
          title: const Text('Guest Checkout'),
          subtitle: const Text('Allow users to order without registration'),
          value: _enableGuestCheckout,
          onChanged: (value) {
            setState(() {
              _enableGuestCheckout = value;
              _markChanged();
            });
          },
        ),
        SwitchListTile(
          title: const Text('Reviews & Ratings'),
          subtitle: const Text('Enable customer reviews'),
          value: _enableReviews,
          onChanged: (value) {
            setState(() {
              _enableReviews = value;
              _markChanged();
            });
          },
        ),
        SwitchListTile(
          title: const Text('Live Tracking'),
          subtitle: const Text('Enable real-time order tracking'),
          value: _enableLiveTracking,
          onChanged: (value) {
            setState(() {
              _enableLiveTracking = value;
              _markChanged();
            });
          },
        ),
      ],
    );
  }

  /// Build system settings
  Widget _buildSystemSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Maintenance Mode'),
          subtitle: const Text('Put the platform in maintenance mode'),
          value: _maintenanceMode,
          onChanged: (value) async {
            if (value) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Enable Maintenance Mode'),
                  content: const Text(
                    'This will make the platform unavailable to all users. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Enable'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                setState(() {
                  _maintenanceMode = value;
                  _markChanged();
                });
              }
            } else {
              setState(() {
                _maintenanceMode = value;
                _markChanged();
              });
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Database Backup',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FilledButton.icon(
              onPressed: () {
                // TODO: Trigger backup
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Creating backup...')),
                );
              },
              icon: const Icon(Icons.backup),
              label: const Text('Create Backup'),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Restore from backup
              },
              icon: const Icon(Icons.restore),
              label: const Text('Restore from Backup'),
            ),
          ],
        ),
      ],
    );
  }

  /// Build slider with label
  Widget _buildSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${value.toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
