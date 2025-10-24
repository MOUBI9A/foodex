import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/ingredient.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Ingredient Card Widget
class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onEdit;
  final VoidCallback onRestock;
  final VoidCallback onDiscard;

  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.onEdit,
    required this.onRestock,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getBorderColor(),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Storage Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStorageColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStorageIcon(),
                      color: _getStorageColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and Category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ingredient.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColorV2.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ingredient.category.label,
                          style: TextStyle(
                            fontSize: 13,
                            color: TColorV2.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  if (ingredient.isExpired)
                    _buildBadge('Expired', TColorV2.error)
                  else if (ingredient.isExpiringSoon)
                    _buildBadge('Expiring Soon', TColorV2.warning)
                  else if (ingredient.isLowStock)
                    _buildBadge('Low Stock', TColorV2.warning),
                ],
              ),
              const SizedBox(height: 16),

              // Quantity and Freshness Row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.inventory_2,
                      label: 'Quantity',
                      value:
                          '${ingredient.quantity.toStringAsFixed(1)} ${ingredient.unit}',
                      color: ingredient.isLowStock
                          ? TColorV2.warning
                          : TColorV2.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.eco,
                      label: 'Freshness',
                      value: '${ingredient.freshnessScore.toStringAsFixed(0)}%',
                      color: _getFreshnessColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Freshness Bar
              _buildFreshnessBar(),
              const SizedBox(height: 12),

              // Expiry and Storage Info
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.event,
                      label: ingredient.expiryDate != null
                          ? 'Expires: ${DateFormat('MMM dd, yyyy').format(ingredient.expiryDate!)}'
                          : 'No expiry date',
                      color: ingredient.isExpired
                          ? TColorV2.error
                          : ingredient.isExpiringSoon
                              ? TColorV2.warning
                              : TColorV2.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.kitchen,
                label: '${ingredient.storageType.label} Storage',
                color: TColorV2.textSecondary,
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TColorV2.primary,
                        side: const BorderSide(color: TColorV2.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRestock,
                      icon: const Icon(Icons.add_circle, size: 16),
                      label: const Text('Restock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColorV2.secondary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onDiscard,
                    icon: const Icon(Icons.delete_outline),
                    color: TColorV2.error,
                    tooltip: 'Discard',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: TColorV2.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreshnessBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Freshness: ${ingredient.freshnessLabel}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: TColorV2.textSecondary,
              ),
            ),
            Text(
              '${ingredient.freshnessScore.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getFreshnessColor(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ingredient.freshnessScore / 100,
            minHeight: 8,
            backgroundColor: TColorV2.neutral200,
            valueColor: AlwaysStoppedAnimation(_getFreshnessColor()),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Color _getBorderColor() {
    if (ingredient.isExpired) return TColorV2.error;
    if (ingredient.isExpiringSoon) return TColorV2.warning;
    if (ingredient.isLowStock) return TColorV2.warning;
    return TColorV2.neutral300;
  }

  Color _getFreshnessColor() {
    if (ingredient.freshnessScore >= 70) return TColorV2.success;
    if (ingredient.freshnessScore >= 40) return TColorV2.warning;
    return TColorV2.error;
  }

  Color _getStorageColor() {
    switch (ingredient.storageType) {
      case StorageType.fridge:
        return TColorV2.info;
      case StorageType.freezer:
        return Colors.lightBlue;
      case StorageType.pantry:
        return Colors.brown;
      case StorageType.countertop:
        return Colors.orange;
    }
  }

  IconData _getStorageIcon() {
    switch (ingredient.storageType) {
      case StorageType.fridge:
        return Icons.kitchen;
      case StorageType.freezer:
        return Icons.ac_unit;
      case StorageType.pantry:
        return Icons.inventory_2;
      case StorageType.countertop:
        return Icons.countertops;
    }
  }
}
