import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/widgets/round_button.dart';

class OrderSuccessView extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final String estimatedDeliveryTime;

  const OrderSuccessView({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.estimatedDeliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Order Placed Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Your order has been confirmed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40),

                // Order Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TColor.textfield,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Order ID", orderId),
                      const SizedBox(height: 15),
                      _buildDetailRow("Total Amount",
                          "\$${totalAmount.toStringAsFixed(2)}"),
                      const SizedBox(height: 15),
                      _buildDetailRow(
                          "Estimated Delivery", estimatedDeliveryTime),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Track Order Button
                RoundButton(
                  title: "Track Order",
                  onPressed: () {
                    context.go('/order-detail/$orderId');
                  },
                ),

                const SizedBox(height: 15),

                // Continue Shopping Button
                RoundButton(
                  title: "Continue Shopping",
                  type: RoundButtonType.textPrimary,
                  onPressed: () {
                    context.go('/main');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
