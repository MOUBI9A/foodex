// IngredientForm: modal for adding/editing an ingredient.
import 'package:flutter/material.dart';
import '../../../data/models/ingredient.dart';
import '../../../core/theme/app_spacing.dart';

class IngredientForm extends StatefulWidget {
  final Ingredient? initial;
  final void Function(Ingredient) onSubmit;
  const IngredientForm({super.key, this.initial, required this.onSubmit});

  @override
  State<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String unit;
  late double quantity;
  late int threshold;
  late String category;
  late String storageType;
  DateTime? expiryDate;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    name = i?.name ?? '';
    unit = i?.unit ?? 'pcs';
    quantity = i?.quantity ?? 1;
    threshold = i?.threshold ?? 1;
    category = i?.category ?? 'General';
    storageType = i?.storageType ?? 'dry';
    expiryDate = i?.expiryDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Add Ingredient' : 'Edit Ingredient'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => name = v!,
              ),
              TextFormField(
                initialValue: unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                onSaved: (v) => unit = v!,
              ),
              TextFormField(
                initialValue: quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v) == null ? 'Enter a number' : null,
                onSaved: (v) => quantity = double.parse(v!),
              ),
              TextFormField(
                initialValue: threshold.toString(),
                decoration: const InputDecoration(labelText: 'Low Stock Threshold'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? 'Enter a number' : null,
                onSaved: (v) => threshold = int.parse(v!),
              ),
              TextFormField(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (v) => category = v!,
              ),
              DropdownButtonFormField<String>(
                initialValue: storageType,
                items: const [
                  DropdownMenuItem(value: 'dry', child: Text('Dry')),
                  DropdownMenuItem(value: 'fridge', child: Text('Fridge')),
                  DropdownMenuItem(value: 'freezer', child: Text('Freezer')),
                ],
                onChanged: (v) => setState(() => storageType = v!),
                decoration: const InputDecoration(labelText: 'Storage Type'),
              ),
              Row(
                children: [
                  const Text('Expiry Date:'),
                  const SizedBox(width: AppSpacing.sm),
                  Text(expiryDate != null ? expiryDate!.toLocal().toString().split(' ')[0] : 'None'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: expiryDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => expiryDate = picked);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSubmit(Ingredient(
                id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                unit: unit,
                quantity: quantity,
                threshold: threshold,
                category: category,
                storageType: storageType,
                expiryDate: expiryDate,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
