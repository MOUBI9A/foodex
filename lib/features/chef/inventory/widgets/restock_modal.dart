import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color_system_v2.dart';
import '../../../../data/models/ingredient.dart';

/// Restock Modal - Quick restock interface for ingredients
class RestockModal extends StatefulWidget {
  final Ingredient ingredient;

  const RestockModal({
    super.key,
    required this.ingredient,
  });

  @override
  State<RestockModal> createState() => _RestockModalState();
}

class _RestockModalState extends State<RestockModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _costController;
  DateTime? _newExpiryDate;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _costController = TextEditingController(
      text: widget.ingredient.costPerUnit.toStringAsFixed(2),
    );
    _newExpiryDate = widget.ingredient.expiryDate;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TColorV2.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_circle,
                        color: TColorV2.secondary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Restock Ingredient',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: TColorV2.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.ingredient.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: TColorV2.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Current Stock Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColorV2.neutral100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Current Stock',
                          '${widget.ingredient.quantity.toStringAsFixed(1)} ${widget.ingredient.unit}',
                          Icons.inventory_2,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: TColorV2.neutral300,
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'Freshness',
                          '${widget.ingredient.freshnessScore.toStringAsFixed(0)}%',
                          Icons.eco,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quantity to Add
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity to Add *',
                    hintText: 'Enter quantity in ${widget.ingredient.unit}',
                    prefixIcon: const Icon(Icons.add_circle_outline),
                    suffixText: widget.ingredient.unit,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity to add';
                    }
                    final double? quantity = double.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Please enter valid quantity';
                    }
                    return null;
                  },
                  autofocus: true,
                ),
                const SizedBox(height: 16),

                // Cost per Unit
                TextFormField(
                  controller: _costController,
                  decoration: InputDecoration(
                    labelText: 'Cost per Unit *',
                    hintText: 'Enter cost',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cost';
                    }
                    final double? cost = double.tryParse(value);
                    if (cost == null || cost < 0) {
                      return 'Please enter valid cost';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // New Expiry Date
                InkWell(
                  onTap: _selectExpiryDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'New Expiry Date',
                      prefixIcon: const Icon(Icons.event),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    child: Text(
                      _newExpiryDate != null
                          ? DateFormat('MMM dd, yyyy').format(_newExpiryDate!)
                          : 'Select date (optional)',
                      style: TextStyle(
                        color: _newExpiryDate != null
                            ? TColorV2.textPrimary
                            : TColorV2.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Calculation Preview
                if (_quantityController.text.isNotEmpty &&
                    double.tryParse(_quantityController.text) != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColorV2.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: TColorV2.success.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New Total:',
                              style: TextStyle(
                                fontSize: 14,
                                color: TColorV2.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(widget.ingredient.quantity + double.parse(_quantityController.text)).toStringAsFixed(1)} ${widget.ingredient.unit}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: TColorV2.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Confirm Restock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColorV2.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: TColorV2.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: TColorV2.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: TColorV2.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _newExpiryDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TColorV2.secondary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: TColorV2.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _newExpiryDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = {
      'quantity': double.parse(_quantityController.text),
      'cost': double.parse(_costController.text),
      'expiryDate': _newExpiryDate,
    };

    Navigator.of(context).pop(result);
  }
}
