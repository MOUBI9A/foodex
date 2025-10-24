import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";

  List<String> categories = [
    "All",
    "Burgers",
    "Pizza",
    "Sushi",
    "Desserts",
    "Drinks"
  ];

  List<Map<String, dynamic>> allItems = [
    {
      "name": "Beef Burger",
      "category": "Burgers",
      "price": 12.50,
      "rating": 4.5,
      "image": "assets/img/item_1.png",
      "restaurant": "Burger House",
    },
    {
      "name": "Margherita Pizza",
      "category": "Pizza",
      "price": 15.00,
      "rating": 4.7,
      "image": "assets/img/item_2.png",
      "restaurant": "Pizza Palace",
    },
    {
      "name": "California Roll",
      "category": "Sushi",
      "price": 18.00,
      "rating": 4.8,
      "image": "assets/img/dess_1.png",
      "restaurant": "Sushi Master",
    },
    {
      "name": "Chocolate Cake",
      "category": "Desserts",
      "price": 8.50,
      "rating": 4.6,
      "image": "assets/img/dess_2.png",
      "restaurant": "Sweet Treats",
    },
    {
      "name": "Fresh Juice",
      "category": "Drinks",
      "price": 5.00,
      "rating": 4.3,
      "image": "assets/img/dess_3.png",
      "restaurant": "Juice Bar",
    },
  ];

  List<Map<String, dynamic>> filteredItems = [];
  List<String> recentSearches = ["Burger", "Pizza", "Sushi", "Pasta"];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty && selectedCategory == "All") {
        filteredItems = allItems;
      } else {
        filteredItems = allItems.where((item) {
          bool matchesSearch = query.isEmpty ||
              item["name"].toLowerCase().contains(query.toLowerCase()) ||
              item["restaurant"].toLowerCase().contains(query.toLowerCase());
          bool matchesCategory =
              selectedCategory == "All" || item["category"] == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();
      }
    });
  }

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
          "Search",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: searchController,
              onChanged: filterItems,
              decoration: InputDecoration(
                hintText: "Search for food or restaurants",
                prefixIcon: Icon(Icons.search, color: TColor.secondaryText),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          filterItems("");
                        },
                        icon: Icon(Icons.clear, color: TColor.secondaryText),
                      )
                    : null,
                filled: true,
                fillColor: TColor.textfield,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                bool isSelected = selectedCategory == category;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      filterItems(searchController.text);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? TColor.primary : TColor.textfield,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? TColor.white : TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Recent Searches (shown when search is empty)
          if (searchController.text.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Searches",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: recentSearches.map((search) {
                      return InkWell(
                        onTap: () {
                          searchController.text = search;
                          filterItems(search);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: TColor.textfield,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.history,
                                  size: 16, color: TColor.secondaryText),
                              const SizedBox(width: 5),
                              Text(
                                search,
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Search Results
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: TColor.placeholder,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No results found",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      var item = filteredItems[index];
                      return _buildSearchResultItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        // Navigate to item details
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
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
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

            // Add to Cart Button
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
                Icons.add_circle,
                color: TColor.primary,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
