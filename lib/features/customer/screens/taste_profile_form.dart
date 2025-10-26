import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../chef/providers/ingredient_provider.dart';
import '../../customer/providers/taste_profile_provider.dart';
import '../../../data/models/taste_profile.dart';

class TasteProfileForm extends ConsumerStatefulWidget {
  const TasteProfileForm({super.key});

  @override
  ConsumerState<TasteProfileForm> createState() => _TasteProfileFormState();
}

class _TasteProfileFormState extends ConsumerState<TasteProfileForm> {
  final _liked = <String>{};
  final _disliked = <String>{};
  final _allergens = <String>{};
  bool _spicy = false;
  bool _healthy = false;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(tasteProfileProvider);
    final ingredientsAsync = ref.watch(ingredientListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Tastes')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileAsync.maybeWhen(
              data: (p) {
                if (p != null) {
                  _liked.addAll(p.likedIngredients);
                  _disliked.addAll(p.dislikedIngredients);
                  _allergens.addAll(p.allergens);
                  _spicy = p.prefersSpicy;
                  _healthy = p.prefersHealthy;
                }
                return const SizedBox.shrink();
              },
              orElse: () => const SizedBox.shrink(),
            ),
            const Text('Tap to toggle tags'),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ingredientsAsync.when(
                data: (ings) => ListView.builder(
                  itemCount: ings.length,
                  itemBuilder: (context, i) {
                    final ing = ings[i];
                    final id = ing.id;
                    return ListTile(
                      title: Text(ing.name),
                      subtitle: Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Like'),
                            selected: _liked.contains(id),
                            onSelected: (v) => setState(() {
                              if (v) {
                                _liked.add(id);
                                _disliked.remove(id);
                              } else {
                                _liked.remove(id);
                              }
                            }),
                          ),
                          FilterChip(
                            label: const Text('Dislike'),
                            selected: _disliked.contains(id),
                            onSelected: (v) => setState(() {
                              if (v) {
                                _disliked.add(id);
                                _liked.remove(id);
                              } else {
                                _disliked.remove(id);
                              }
                            }),
                          ),
                          FilterChip(
                            label: const Text('Allergen'),
                            selected: _allergens.contains(id),
                            onSelected: (v) => setState(() {
                              if (v) {
                                _allergens.add(id);
                              } else {
                                _allergens.remove(id);
                              }
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Prefer spicy'),
                    value: _spicy,
                    onChanged: (v) => setState(() => _spicy = v),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Prefer healthy'),
                    value: _healthy,
                    onChanged: (v) => setState(() => _healthy = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final profile = TasteProfile(
                    likedIngredients: _liked.toList(),
                    dislikedIngredients: _disliked.toList(),
                    allergens: _allergens.toList(),
                    cuisines: const [],
                    prefersSpicy: _spicy,
                    prefersHealthy: _healthy,
                  );
                  final navigator = Navigator.of(context);
                  await ref.read(tasteProfileProvider.notifier).save(profile);
                  navigator.pop();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
