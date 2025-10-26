import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/features/location/providers/delivery_location_provider.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';
import 'package:food_delivery/presentation/pages/location/delivery_map_picker_view.dart';

class DeliveryLocationSheet extends ConsumerWidget {
  const DeliveryLocationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deliveryLocationProvider);
    final notifier = ref.read(deliveryLocationProvider.notifier);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Text(
              l10n.deliveryLocationTitle,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.deliveryLocationSheetDescription,
              style: TextStyle(color: TColor.secondaryText, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _TileOption(
              icon: Icons.my_location,
              title: l10n.useCurrentLocation,
              subtitle: l10n.useCurrentSubtitle,
              color: Colors.teal,
              trailing: state.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: state.isLoading
                  ? null
                  : () async {
                      try {
                        await notifier.setLiveLocation(
                          label: l10n.useCurrentLocation,
                        );
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
            ),
            const SizedBox(height: 12),
            _TileOption(
              icon: Icons.map_outlined,
              title: l10n.chooseOnMap,
              subtitle: l10n.chooseOnMapSubtitle,
              color: Colors.deepOrange,
              onTap: () async {
                if (state.isLoading) return;
                if (!context.mounted) return;
                final result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliveryMapPickerView(),
                    fullscreenDialog: true,
                  ),
                );
                if (result == true && context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TileOption extends StatelessWidget {
  const _TileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              trailing ??
                  Icon(Icons.chevron_right, color: TColor.secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}
