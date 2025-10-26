// RestockModal: modal for restocking an ingredient.
import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class RestockModal extends StatefulWidget {
  final void Function(double qty, DateTime? expiry) onSubmit;
  const RestockModal({super.key, required this.onSubmit});

  @override
  State<RestockModal> createState() => _RestockModalState();
}

class _RestockModalState extends State<RestockModal> {
  final _formKey = GlobalKey<FormState>();
  double qty = 1;
  DateTime? expiry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Restock Ingredient'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: qty.toString(),
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || double.tryParse(v) == null ? 'Enter a number' : null,
              onSaved: (v) => qty = double.parse(v!),
            ),
            Row(
              children: [
                const Text('Expiry Date:'),
                const SizedBox(width: AppSpacing.sm),
                Text(expiry != null ? expiry!.toLocal().toString().split(' ')[0] : 'None'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: expiry ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => expiry = picked);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSubmit(qty, expiry);
              Navigator.pop(context);
            }
          },
          child: const Text('Restock'),
        ),
      ],
    );
  }
}
