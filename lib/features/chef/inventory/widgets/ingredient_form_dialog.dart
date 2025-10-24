import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/ingredient.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Ingredient Form Dialog - For adding or editing ingredients
class IngredientFormDialog extends StatefulWidget {
  final Ingredient? ingredient; // null for add, non-null for edit
  final String chefId;

  const IngredientFormDialog({
    super.key,
    this.ingredient,
    required this.chefId,
  });

  @override
  State<IngredientFormDialog> createState() => _IngredientFormDialogState();
}

class _IngredientFormDialogState extends State<IngredientFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _thresholdController;
  late TextEditingController _costController;

  late IngredientCategory _selectedCategory;
  late StorageType _selectedStorageType;
  late String _selectedUnit;
  DateTime? _selectedExpiryDate;

  bool get isEditMode => widget.ingredient != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (isEditMode) {
      final ingredient = widget.ingredient!;
      _nameController = TextEditingController(text: ingredient.name);
      _quantityController =
          TextEditingController(text: ingredient.quantity.toString());
      _thresholdController =
          TextEditingController(text: ingredient.threshold.toString());
      _costController = TextEditingController(
          text: ingredient.costPerUnit.toStringAsFixed(2));

      _selectedCategory = ingredient.category;
      _selectedStorageType = ingredient.storageType;
      _selectedUnit = ingredient.unit;
      _selectedExpiryDate = ingredient.expiryDate;
    } else {
      _nameController = TextEditingController();
      _quantityController = TextEditingController();
      _thresholdController = TextEditingController(text: '5');
      _costController = TextEditingController();

      _selectedCategory = IngredientCategory.vegetables;
      _selectedStorageType = StorageType.fridge;
      _selectedUnit = 'kg';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  isEditMode ? 'Edit Ingredient' : 'Add New Ingredient',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: TColorV2.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Ingredient Name *',
                    hintText: 'e.g., Tomatoes',
                    prefixIcon: const Icon(Icons.inventory_2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter ingredient name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category and Storage Type
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<IngredientCategory>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: IngredientCategory.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<StorageType>(
                        value: _selectedStorageType,
                        decoration: InputDecoration(
                          labelText: 'Storage *',
                          prefixIcon: const Icon(Icons.kitchen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: StorageType.values
                            .map((storage) => DropdownMenuItem(
                                  value: storage,
                                  child: Text(storage.label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStorageType = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quantity and Unit
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity *',
                          prefixIcon: const Icon(Icons.shopping_basket),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final num? quantity = double.tryParse(value);
                          if (quantity == null || quantity <= 0) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'kg', child: Text('kg')),
                          DropdownMenuItem(value: 'g', child: Text('g')),
                          DropdownMenuItem(value: 'L', child: Text('L')),
                          DropdownMenuItem(value: 'mL', child: Text('mL')),
                          DropdownMenuItem(value: 'pcs', child: Text('pcs')),
                          DropdownMenuItem(
                              value: 'dozen', child: Text('dozen')),
                          DropdownMenuItem(value: 'pack', child: Text('pack')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedUnit = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Threshold and Cost
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _thresholdController,
                        decoration: InputDecoration(
                          labelText: 'Low Stock Alert *',
                          prefixIcon: const Icon(Icons.warning_amber),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final num? threshold = double.tryParse(value);
                          if (threshold == null || threshold < 0) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _costController,
                        decoration: InputDecoration(
                          labelText: 'Cost per Unit *',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final num? cost = double.tryParse(value);
                          if (cost == null || cost < 0) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Expiry Date
                InkWell(
                  onTap: _selectExpiryDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      prefixIcon: const Icon(Icons.event),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selectedExpiryDate != null
                          ? DateFormat('MMM dd, yyyy')
                              .format(_selectedExpiryDate!)
                          : 'Select date (optional)',
                      style: TextStyle(
                        color: _selectedExpiryDate != null
                            ? TColorV2.textPrimary
                            : TColorV2.textSecondary,
                      ),
                    ),
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
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColorV2.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: Text(isEditMode ? 'Update' : 'Add'),
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

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedExpiryDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TColorV2.primary,
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
      setState(() => _selectedExpiryDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredient = Ingredient(
      id: isEditMode
          ? widget.ingredient!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      chefId: widget.chefId,
      name: _nameController.text.trim(),
      category: _selectedCategory,
      unit: _selectedUnit,
      quantity: double.parse(_quantityController.text),
      threshold: double.parse(_thresholdController.text),
      costPerUnit: double.parse(_costController.text),
      addedAt: isEditMode ? widget.ingredient!.addedAt : DateTime.now(),
      expiryDate: _selectedExpiryDate,
      freshnessScore: 100.0,
      storageType: _selectedStorageType,
      lastChecked: DateTime.now(),
      updatedAt: DateTime.now(),
      history: isEditMode ? widget.ingredient!.history : [],
    );

    Navigator.of(context).pop(ingredient);
  }
}
