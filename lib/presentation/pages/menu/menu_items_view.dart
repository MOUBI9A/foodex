import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/widgets/menu_item_row.dart';
import 'package:food_delivery/presentation/widgets/round_textfield.dart';
import 'package:food_delivery/l10n/generated/app_localizations.dart';

import '../more/my_order_view.dart';
import 'item_details_view.dart';

class MenuItemsView extends StatefulWidget {
  final Map mObj;
  const MenuItemsView({super.key, required this.mObj});

  @override
  State<MenuItemsView> createState() => _MenuItemsViewState();
}

class _MenuItemsViewState extends State<MenuItemsView> {
  late final TextEditingController txtSearch;
  String _searchQuery = '';

  final List<Map<String, String>> menuItemsArr = [
    {
      "image": "assets/images/dess_1.png",
      "name": "Saffron Orange Cake",
      "rate": "4.9",
      "rating": "124",
      "type": "Atelier Zineb",
      "food_type": "Desserts"
    },
    {
      "image": "assets/images/dess_2.png",
      "name": "Dark Fig Chocolate",
      "rate": "4.8",
      "rating": "98",
      "type": "Café Atlas",
      "food_type": "Desserts"
    },
    {
      "image": "assets/images/dess_3.png",
      "name": "Mint Tea Shake",
      "rate": "4.7",
      "rating": "87",
      "type": "La Terrasse",
      "food_type": "Beverages"
    },
    {
      "image": "assets/images/dess_4.png",
      "name": "Honey Almond Brownie",
      "rate": "5.0",
      "rating": "142",
      "type": "Minute by Tuk Tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/images/menu_2.png",
      "name": "Almond Date Smoothie",
      "rate": "4.8",
      "rating": "110",
      "type": "Press & Sips",
      "food_type": "Beverages"
    },
    {
      "image": "assets/images/menu_3.png",
      "name": "Rosewater Briouat",
      "rate": "4.9",
      "rating": "75",
      "type": "Chef Laila",
      "food_type": "Desserts"
    },
  ];

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

  List<Map<String, String>> get _filteredItems {
    if (_searchQuery.isEmpty) return menuItemsArr;
    return menuItemsArr
        .where((item) =>
            item["name"]!.toLowerCase().contains(_searchQuery) ||
            item["type"]!.toLowerCase().contains(_searchQuery) ||
            item["food_type"]!.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/images/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        widget.mObj["name"].toString(),
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/images/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: l10n.menuItemsSearchHint,
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/images/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Builder(builder: (context) {
                final items = _filteredItems;
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 60),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cookie_outlined,
                          size: 56,
                          color: TColor.secondaryText.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.menuItemsEmptyTitle,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.menuItemsEmptyBody,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final mObj = items[index];
                    return MenuItemRow(
                      mObj: mObj,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ItemDetailsView(),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
