import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/core/routing/app_router.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Beef Burger",
      "description": "With extra cheese",
      "price": 12.50,
      "quantity": 2,
      "image": "assets/img/item_1.png",
    },
    {
      "name": "Chicken Pizza",
      "description": "Medium size",
      "price": 18.00,
      "quantity": 1,
      "image": "assets/img/item_2.png",
    },
    {
      "name": "French Fries",
      "description": "Large portion",
      "price": 5.50,
      "quantity": 3,
      "image": "assets/img/item_3.png",
    },
  ];

  double deliveryFee = 5.00;
  double serviceFee = 2.50;

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
        0, (sum, item) => sum + (item["price"] * item["quantity"]));
    double total = subtotal + deliveryFee + serviceFee;

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
          "My Cart",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
              });
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return _buildCartItem(item, index);
              },
            ),
          ),

          // Bill Details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColor.textfield,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                _buildBillRow("Subtotal", subtotal),
                const SizedBox(height: 10),
                _buildBillRow("Delivery Fee", deliveryFee),
                const SizedBox(height: 10),
                _buildBillRow("Service Fee", serviceFee),
                const Divider(height: 30),
                _buildBillRow("Total", total, isTotal: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.checkout);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
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
                  item["description"],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
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
          ),

          // Quantity Controls
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    cartItems.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.red,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (item["quantity"] > 1) {
                            item["quantity"]--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove, size: 18),
                    ),
                    Text(
                      "${item["quantity"]}",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          item["quantity"]++;
                        });
                      },
                      icon: Icon(Icons.add, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? TColor.primaryText : TColor.secondaryText,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: isTotal ? TColor.primary : TColor.primaryText,
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
