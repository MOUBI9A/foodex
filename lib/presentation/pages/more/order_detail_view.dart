import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class OrderDetailView extends StatefulWidget {
  final String orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  // Mock order data - in real app, fetch from API using widget.orderId
  late Map<String, dynamic> orderData;

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  void _loadOrderData() {
    // Mock data - replace with actual API call
    orderData = {
      'id': widget.orderId,
      'orderNumber': '#ORD-${widget.orderId}',
      'status': 'In Progress',
      'statusColor': Colors.orange,
      'date': 'Oct 22, 2025',
      'time': '2:30 PM',
      'chef': {
        'name': 'Chef Amina',
        'image': 'assets/img/m_res_1.png',
        'phone': '+212 6XX-XXXXXX',
      },
      'driver': {
        'name': 'Mohamed',
        'image': 'assets/img/m_res_2.png',
        'phone': '+212 6XX-XXXXXX',
      },
      'items': [
        {
          'name': 'Moroccan Tagine',
          'quantity': 2,
          'price': 80.0,
        },
        {
          'name': 'Couscous Royal',
          'quantity': 1,
          'price': 120.0,
        },
      ],
      'deliveryAddress': {
        'street': '123 Rue Mohammed V',
        'city': 'Casablanca',
        'details': 'Apartment 4B, Building 2',
      },
      'pricing': {
        'subtotal': 280.0,
        'deliveryFee': 20.0,
        'serviceFee': 14.0,
        'total': 314.0,
      },
      'paymentMethod': 'Cash on Delivery',
      'timeline': [
        {'title': 'Order Placed', 'time': '2:30 PM', 'completed': true},
        {'title': 'Chef Confirmed', 'time': '2:32 PM', 'completed': true},
        {'title': 'Preparing Food', 'time': '2:35 PM', 'completed': true},
        {'title': 'Driver Assigned', 'time': '3:10 PM', 'completed': false},
        {'title': 'Out for Delivery', 'time': '', 'completed': false},
        {'title': 'Delivered', 'time': '', 'completed': false},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TColor.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColor.textfield,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderData['orderNumber'],
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: orderData['statusColor'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          orderData['status'],
                          style: TextStyle(
                            color: orderData['statusColor'],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${orderData['date']} at ${orderData['time']}',
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Order Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Order Status',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildTimeline(),

            const SizedBox(height: 30),

            // Chef & Driver Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Contact Information',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildContactCard('Chef', orderData['chef']),
            if (orderData['driver'] != null)
              _buildContactCard('Driver', orderData['driver']),

            const SizedBox(height: 30),

            // Order Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Order Items',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ...orderData['items'].map((item) => _buildOrderItem(item)).toList(),

            const SizedBox(height: 30),

            // Delivery Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Delivery Address',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildAddressCard(),

            const SizedBox(height: 30),

            // Price Breakdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Price Breakdown',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildPriceBreakdown(),

            const SizedBox(height: 30),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (orderData['status'] == 'In Progress')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _showCancelOrderDialog();
                        },
                        child: Text(
                          'Cancel Order',
                          style: TextStyle(
                            color: TColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: TColor.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Contact support
                      },
                      child: Text(
                        'Need Help?',
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: orderData['timeline'].map<Widget>((step) {
          final index = orderData['timeline'].indexOf(step);
          final isLast = index == orderData['timeline'].length - 1;
          final isCompleted = step['completed'];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isCompleted ? TColor.primary : TColor.textfield,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isCompleted ? TColor.primary : TColor.secondaryText,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? Icon(Icons.check, color: TColor.white, size: 16)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color:
                          isCompleted ? TColor.primary : TColor.secondaryText,
                    ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'],
                      style: TextStyle(
                        color: isCompleted
                            ? TColor.primaryText
                            : TColor.secondaryText,
                        fontSize: 15,
                        fontWeight:
                            isCompleted ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (step['time'].isNotEmpty)
                      Text(
                        step['time'],
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    if (!isLast) const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactCard(String role, Map<String, dynamic> person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              person['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
                Text(
                  person['name'],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.phone, color: TColor.primary),
            onPressed: () {
              // Call phone number
            },
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: TColor.primary),
            onPressed: () {
              // Open chat
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${item['quantity']}x ${item['name']}',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${item['price'].toStringAsFixed(2)} DH',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    final address = orderData['deliveryAddress'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: TColor.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['street'],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  address['city'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 13,
                  ),
                ),
                if (address['details'] != null && address['details'].isNotEmpty)
                  Text(
                    address['details'],
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final pricing = orderData['pricing'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', pricing['subtotal']),
          _buildPriceRow('Delivery Fee', pricing['deliveryFee']),
          _buildPriceRow('Service Fee', pricing['serviceFee']),
          const Divider(height: 20),
          _buildPriceRow('Total', pricing['total'], isTotal: true),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.payment, color: TColor.secondaryText, size: 16),
              const SizedBox(width: 8),
              Text(
                orderData['paymentMethod'],
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? TColor.primaryText : TColor.secondaryText,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} DH',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Order?',
          style: TextStyle(color: TColor.primaryText),
        ),
        content: Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: TextStyle(color: TColor.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: TextStyle(color: TColor.secondaryText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // Cancel order logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order cancelled successfully')),
              );
              Navigator.pop(context);
            },
            child: Text('Yes, Cancel', style: TextStyle(color: TColor.white)),
          ),
        ],
      ),
    );
  }
}
