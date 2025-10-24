import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  List<Map<String, dynamic>> favoriteItems = [
    {
      "name": "Beef Burger",
      "restaurant": "Burger House",
      "price": 12.50,
      "rating": 4.5,
      "image": "assets/img/item_1.png",
      "category": "Fast Food",
    },
    {
      "name": "Margherita Pizza",
      "restaurant": "Pizza Palace",
      "price": 15.00,
      "rating": 4.7,
      "image": "assets/img/item_2.png",
      "category": "Italian",
    },
    {
      "name": "Chocolate Cake",
      "restaurant": "Sweet Treats",
      "price": 8.50,
      "rating": 4.6,
      "image": "assets/img/dess_1.png",
      "category": "Dessert",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primaryText,
          ),
        ),
        title: Text(
          "My Favorites",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: favoriteItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: TColor.placeholder,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No favorites yet",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Start adding your favorite dishes!",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                var item = favoriteItems[index];
                return _buildFavoriteItem(item, index);
              },
            ),
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> item, int index) {
    return InkWell(
      onTap: () {
        context.go('/item-details');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TColor.textfield,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item["image"],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: TColor.placeholder,
                    child: Icon(Icons.restaurant, color: TColor.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"],
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["restaurant"],
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["category"],
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${item["rating"]}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "\$${item["price"].toStringAsFixed(2)}",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      favoriteItems.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Removed from favorites"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${item["name"]} added to cart"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: TColor.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
