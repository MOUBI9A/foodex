import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/ingredient.dart';
import '../../../../core/providers/ingredient_provider.dart';

/// Admin Analytics Data Model
class AdminAnalytics {
  final int totalIngredients;
  final int lowStockCount;
  final int expiringSoonCount;
  final int expiredCount;
  final double totalInventoryValue;
  final List<Ingredient> ingredients;
  final Map<IngredientCategory, int> categoryDistribution;
  final Map<StorageType, int> storageDistribution;
  final Map<String, int> wasteByCategory;
  final List<IngredientUsageTrend> usageTrends;

  AdminAnalytics({
    required this.totalIngredients,
    required this.lowStockCount,
    required this.expiringSoonCount,
    required this.expiredCount,
    required this.totalInventoryValue,
    required this.ingredients,
    required this.categoryDistribution,
    required this.storageDistribution,
    required this.wasteByCategory,
    required this.usageTrends,
  });

  double get averageFreshness {
    if (ingredients.isEmpty) return 0;
    final total = ingredients.fold<double>(
      0,
      (sum, ingredient) => sum + ingredient.freshnessScore,
    );
    return total / ingredients.length;
  }

  int get healthyStockCount => totalIngredients - lowStockCount - expiredCount;
}

/// Ingredient Usage Trend (for line chart)
class IngredientUsageTrend {
  final DateTime date;
  final int added;
  final int used;
  final int expired;
  final int discarded;

  IngredientUsageTrend({
    required this.date,
    required this.added,
    required this.used,
    required this.expired,
    required this.discarded,
  });
}

/// Provider for all admin analytics data
final adminAnalyticsProvider = FutureProvider.family<AdminAnalytics, String>(
  (ref, chefId) async {
    // Get all ingredients for the chef using the listProvider
    final ingredientsAsync = ref.watch(ingredientListProvider(chefId));

    // Wait for the async value to resolve
    final allIngredients = await ingredientsAsync.when(
      data: (ingredients) async => ingredients,
      loading: () async => <Ingredient>[],
      error: (error, stack) async => <Ingredient>[],
    );

    // Calculate KPIs
    final total = allIngredients.length;
    final lowStock = allIngredients.where((i) => i.isLowStock).length;
    final expiringSoon = allIngredients.where((i) => i.isExpiringSoon).length;
    final expired = allIngredients.where((i) => i.isExpired).length;

    // Calculate total inventory value
    final totalValue = allIngredients.fold<double>(
      0,
      (sum, ingredient) => sum + (ingredient.quantity * ingredient.costPerUnit),
    );

    // Category distribution
    final categoryDist = <IngredientCategory, int>{};
    for (final category in IngredientCategory.values) {
      categoryDist[category] =
          allIngredients.where((i) => i.category == category).length;
    }

    // Storage distribution
    final storageDist = <StorageType, int>{};
    for (final storage in StorageType.values) {
      storageDist[storage] =
          allIngredients.where((i) => i.storageType == storage).length;
    }

    // Waste by category (expired + discarded)
    final wasteByCategory = <String, int>{};
    for (final category in IngredientCategory.values) {
      final expiredInCategory = allIngredients
          .where((i) => i.category == category && i.isExpired)
          .length;

      // Count discarded from history
      final discardedInCategory = allIngredients
          .where((i) => i.category == category)
          .fold<int>(
            0,
            (sum, ingredient) =>
                sum +
                ingredient.history.where((h) => h.action == 'discarded').length,
          );

      wasteByCategory[category.label] = expiredInCategory + discardedInCategory;
    }

    // Usage trends (last 7 days)
    final usageTrends = _calculateUsageTrends(allIngredients);

    return AdminAnalytics(
      totalIngredients: total,
      lowStockCount: lowStock,
      expiringSoonCount: expiringSoon,
      expiredCount: expired,
      totalInventoryValue: totalValue,
      ingredients: allIngredients,
      categoryDistribution: categoryDist,
      storageDistribution: storageDist,
      wasteByCategory: wasteByCategory,
      usageTrends: usageTrends,
    );
  },
);

/// Helper function to calculate usage trends
List<IngredientUsageTrend> _calculateUsageTrends(List<Ingredient> ingredients) {
  final trends = <IngredientUsageTrend>[];
  final now = DateTime.now();

  // Generate last 7 days
  for (int i = 6; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    final dateKey = DateTime(date.year, date.month, date.day);

    int added = 0;
    int used = 0;
    int expired = 0;
    int discarded = 0;

    for (final ingredient in ingredients) {
      // Count from history
      for (final historyItem in ingredient.history) {
        final historyDate = DateTime(
          historyItem.date.year,
          historyItem.date.month,
          historyItem.date.day,
        );

        if (historyDate == dateKey) {
          switch (historyItem.action) {
            case 'added':
            case 'restocked':
              added++;
              break;
            case 'used':
              used++;
              break;
            case 'expired':
              expired++;
              break;
            case 'discarded':
              discarded++;
              break;
          }
        }
      }
    }

    trends.add(IngredientUsageTrend(
      date: dateKey,
      added: added,
      used: used,
      expired: expired,
      discarded: discarded,
    ));
  }

  return trends;
}

/// Provider for storage distribution data (for pie chart)
final storageDistributionProvider =
    Provider.family<Map<StorageType, int>, String>(
  (ref, chefId) {
    final analytics = ref.watch(adminAnalyticsProvider(chefId));
    return analytics.when(
      data: (data) => data.storageDistribution,
      loading: () => {},
      error: (_, __) => {},
    );
  },
);

/// Provider for waste data (for bar chart)
final wasteDataProvider = Provider.family<Map<String, int>, String>(
  (ref, chefId) {
    final analytics = ref.watch(adminAnalyticsProvider(chefId));
    return analytics.when(
      data: (data) => data.wasteByCategory,
      loading: () => {},
      error: (_, __) => {},
    );
  },
);

/// Provider for usage trends (for line chart)
final usageTrendsProvider = Provider.family<List<IngredientUsageTrend>, String>(
  (ref, chefId) {
    final analytics = ref.watch(adminAnalyticsProvider(chefId));
    return analytics.when(
      data: (data) => data.usageTrends,
      loading: () => [],
      error: (_, __) => [],
    );
  },
);
