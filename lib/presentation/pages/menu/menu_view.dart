import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/widgets/round_textfield.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';

import '../more/my_order_view.dart';
import 'menu_items_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  static const List<String> _filterIds = [
    'all',
    'meals',
    'family',
    'quick',
    'beverages',
    'desserts',
    'promotions',
  ];

  final List<Map<String, dynamic>> _menuArr = [
    {
      "name": "Home Chef Classics",
      "image": "assets/images/menu_1.png",
      "items_count": 48,
      "description": "Slow tagines, couscous & warm trays built for sharing.",
      "tags": ["meals", "family"],
      "eta": "45 min avg",
      "featured": true,
    },
    {
      "name": "Fresh Press & Sips",
      "image": "assets/images/menu_2.png",
      "items_count": 32,
      "description": "Cold-pressed juices, almond smoothies and mint tea.",
      "tags": ["beverages", "quick"],
      "eta": "20 min avg",
      "featured": false,
    },
    {
      "name": "Sweet Medina Bakes",
      "image": "assets/images/menu_3.png",
      "items_count": 26,
      "description":
          "Msemen, briouat and honey-dipped desserts from local bakers.",
      "tags": ["desserts"],
      "eta": "35 min avg",
      "featured": true,
    },
    {
      "name": "Seasonal Promotions",
      "image": "assets/images/menu_4.png",
      "items_count": 12,
      "description":
          "Limited drops with bundle pricing and chef tasting boxes.",
      "tags": ["promotions", "meals"],
      "eta": "Varies",
      "featured": false,
    },
  ];

  late final TextEditingController txtSearch;
  String _activeFilter = _filterIds.first;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    txtSearch = TextEditingController();
    txtSearch.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    txtSearch.removeListener(_handleSearchChanged);
    txtSearch.dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final nextQuery = txtSearch.text.trim().toLowerCase();
    if (nextQuery == _searchQuery) return;
    setState(() {
      _searchQuery = nextQuery;
    });
  }

  void _onFilterSelected(String value) {
    if (_activeFilter == value) return;
    setState(() {
      _activeFilter = value;
    });
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> get _filteredMenu {
    return _menuArr.where((menu) {
      final tags = (menu["tags"] as List).cast<String>();
      final matchesFilter =
          _activeFilter == _filterIds.first || tags.contains(_activeFilter);
      final matchesSearch = _searchQuery.isEmpty ||
          menu["name"]
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          menu["description"]
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final visibleMenus = _filteredMenu;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: 160,
            bottom: 100,
            left: 0,
            child: Container(
              width: media.width * 0.24,
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              displacement: 60,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context, l10n)),
                  SliverToBoxAdapter(child: _buildSearchField(l10n)),
                  SliverToBoxAdapter(child: _buildFilterChips(l10n)),
                  SliverToBoxAdapter(
                    child: _buildResultMeta(l10n, visibleMenus.length),
                  ),
                  if (visibleMenus.isEmpty)
                    SliverToBoxAdapter(child: _buildEmptyState(l10n))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final menu = visibleMenus[index];
                            return _MenuCategoryCard(
                              menu: menu,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MenuItemsView(mObj: menu),
                                  ),
                                );
                              },
                              chefPickLabel: l10n.menuChefPick,
                              itemsCountLabel: (count) =>
                                  l10n.menuItemsCount(count),
                              tagLabelBuilder: (tagId) =>
                                  _localizedFilterLabel(l10n, tagId),
                            );
                          },
                          childCount: visibleMenus.length,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.menuTitle,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.menuSubtitle,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOrderView()),
              );
            },
            icon: Image.asset(
              "assets/images/shopping_cart.png",
              width: 26,
              height: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RoundTextfield(
        hintText: l10n.menuSearchHint,
        controller: txtSearch,
        left: Container(
          alignment: Alignment.center,
          width: 36,
          child: Image.asset(
            "assets/images/search.png",
            width: 18,
            height: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(AppLocalizations l10n) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final filterId = _filterIds[index];
          final isSelected = _activeFilter == filterId;
          final filterLabel = _localizedFilterLabel(l10n, filterId);
          return ChoiceChip(
            label: Text(filterLabel),
            selected: isSelected,
            onSelected: (_) => _onFilterSelected(filterId),
            selectedColor: TColor.primary.withOpacity(0.18),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? TColor.primary : TColor.secondaryText,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? TColor.primary
                    : TColor.primary.withOpacity(0.1),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: _filterIds.length,
      ),
    );
  }

  Widget _buildResultMeta(AppLocalizations l10n, int count) {
    final hasActiveSearch =
        _searchQuery.isNotEmpty || _activeFilter != _filterIds.first;
    final label = hasActiveSearch
        ? l10n.menuResultCurated(
            count, _localizedFilterLabel(l10n, _activeFilter))
        : l10n.menuResultDefault;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                label,
                key: ValueKey(label),
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Text(
            l10n.menuCategoriesCount(count),
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: TColor.secondaryText.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.menuEmptyTitle,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.menuEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () {
              setState(() {
                _activeFilter = _filterIds.first;
                _searchQuery = '';
                txtSearch.clear();
              });
            },
            child: Text(l10n.menuResetFilters),
          ),
        ],
      ),
    );
  }

  String _localizedFilterLabel(AppLocalizations l10n, String filterId) {
    switch (filterId) {
      case 'meals':
        return l10n.menuFilterMeals;
      case 'family':
        return l10n.menuFilterFamily;
      case 'quick':
        return l10n.menuFilterQuick;
      case 'beverages':
        return l10n.menuFilterBeverages;
      case 'desserts':
        return l10n.menuFilterDesserts;
      case 'promotions':
        return l10n.menuFilterPromotions;
      default:
        return l10n.menuFilterAll;
    }
  }
}

class _MenuCategoryCard extends StatelessWidget {
  final Map<String, dynamic> menu;
  final VoidCallback onTap;
  final String chefPickLabel;
  final String Function(int) itemsCountLabel;
  final String Function(String) tagLabelBuilder;
  const _MenuCategoryCard({
    required this.menu,
    required this.onTap,
    required this.chefPickLabel,
    required this.itemsCountLabel,
    required this.tagLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final tags = (menu["tags"] as List).cast<String>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    menu["image"],
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              menu["name"],
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (menu["featured"] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: TColor.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                chefPickLabel,
                                style: TextStyle(
                                  color: TColor.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        menu["description"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: TColor.accent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  tagLabelBuilder(tag),
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text(
                            itemsCountLabel(menu["items_count"] as int),
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: TColor.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            menu["eta"],
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: TColor.primary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
