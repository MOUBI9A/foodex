import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class ChefMenuView extends StatefulWidget {
  const ChefMenuView({super.key});

  @override
  State<ChefMenuView> createState() => _ChefMenuViewState();
}

class _ChefMenuViewState extends State<ChefMenuView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> menuCategories = [
    {"name": "Main Dishes", "count": 8},
    {"name": "Appetizers", "count": 5},
    {"name": "Desserts", "count": 6},
    {"name": "Beverages", "count": 4},
  ];

  final List<Map<String, dynamic>> mainDishes = [
    {
      "name": "Chicken Biryani",
      "price": 15.99,
      "description": "Aromatic basmati rice with tender chicken pieces",
  "image": "assets/images/item_1.png",
      "available": true,
      "cooking_time": 30,
      "category": "Indian",
    },
    {
      "name": "Homemade Pasta",
      "price": 12.50,
      "description": "Fresh pasta with homemade tomato sauce",
  "image": "assets/images/item_2.png",
      "available": true,
      "cooking_time": 20,
      "category": "Italian",
    },
    {
      "name": "Grilled Salmon",
      "price": 18.99,
      "description": "Fresh salmon with herbs and lemon",
      "image": "assets/img/item_3.png",
      "available": false,
      "cooking_time": 25,
      "category": "Seafood",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Menu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showAddDishDialog();
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search dishes...",
                        hintStyle: TextStyle(color: TColor.placeholder),
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.search, color: TColor.placeholder),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Category Tabs
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: TColor.primaryText,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: menuCategories
                    .map((category) => Tab(
                          text: "${category['name']} (${category['count']})",
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Menu Items
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMainDishesTab(),
                  _buildAppetizersTab(),
                  _buildDessertsTab(),
                  _buildBeveragesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDishesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: mainDishes.length,
      itemBuilder: (context, index) {
        final dish = mainDishes[index];
        return _buildDishCard(dish);
      },
    );
  }

  Widget _buildAppetizersTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: TColor.placeholder),
          const SizedBox(height: 20),
          Text(
            "No appetizers added yet",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddDishDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Add First Appetizer"),
          ),
        ],
      ),
    );
  }

  Widget _buildDessertsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cake, size: 80, color: TColor.placeholder),
          const SizedBox(height: 20),
          Text(
            "No desserts added yet",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddDishDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Add First Dessert"),
          ),
        ],
      ),
    );
  }

  Widget _buildBeveragesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_drink, size: 80, color: TColor.placeholder),
          const SizedBox(height: 20),
          Text(
            "No beverages added yet",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddDishDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Add First Beverage"),
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(Map<String, dynamic> dish) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dish Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(dish['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Dish Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dish['name'],
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Switch(
                      value: dish['available'],
                      onChanged: (value) {
                        setState(() {
                          dish['available'] = value;
                        });
                      },
                      thumbColor: WidgetStatePropertyAll(TColor.primary),
                    ),
                  ],
                ),
                Text(
                  dish['description'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${dish['price'].toStringAsFixed(2)}",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${dish['cooking_time']} min",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showEditDishDialog(dish),
                          child: Icon(
                            Icons.edit,
                            color: TColor.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showDeleteConfirmation(dish),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Dish"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Dish Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                  prefixText: "\$",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Cooking Time (minutes)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Add dish logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dish added successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add Dish"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDishDialog(Map<String, dynamic> dish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit ${dish['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Dish Name",
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dish['name']),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: "Price",
                  border: const OutlineInputBorder(),
                  prefixText: "\$",
                ),
                controller:
                    TextEditingController(text: dish['price'].toString()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: "Description",
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dish['description']),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Update dish logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dish updated successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> dish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Dish"),
          content: Text("Are you sure you want to delete ${dish['name']}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mainDishes.remove(dish);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dish deleted successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
