import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class HelpSupportView extends StatefulWidget {
  const HelpSupportView({super.key});

  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView> {
  List<Map<String, dynamic>> faqList = [
    {
      'question': 'How do I place an order?',
      'answer':
          'Browse our home chefs menu, select items, add to cart, and proceed to checkout. You can pay cash on delivery.',
      'isExpanded': false,
    },
    {
      'question': 'How can I track my order?',
      'answer':
          'Go to "My Orders" section to see real-time tracking of your active orders. You will also receive notifications for order updates.',
      'isExpanded': false,
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We currently accept Cash on Delivery and Wallet payments. Card payments coming soon!',
      'isExpanded': false,
    },
    {
      'question': 'How do I become a Home Chef?',
      'answer':
          'Sign up as a Home Chef, complete your profile with required documents, create your menu, and start accepting orders!',
      'isExpanded': false,
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can reach us via the Inbox feature, email us at support@foodex.ma, or call +212 5XX-XXXXXX',
      'isExpanded': false,
    },
    {
      'question': 'Can I cancel my order?',
      'answer':
          'Yes, you can cancel orders within 10 minutes of placement. After that, please contact the chef or customer support.',
      'isExpanded': false,
    },
    {
      'question': 'How does the wallet work?',
      'answer':
          'Add money to your wallet and use it for faster checkout. You can top up anytime and track all transactions in the wallet section.',
      'isExpanded': false,
    },
    {
      'question': 'Are the chefs verified?',
      'answer':
          'Yes! All home chefs go through a verification process including ID verification and health & safety checks.',
      'isExpanded': false,
    },
  ];

  List<Map<String, dynamic>> contactOptions = [
    {
      'icon': Icons.email_outlined,
      'title': 'Email Support',
      'subtitle': 'support@foodex.ma',
      'action': 'mailto:support@foodex.ma',
    },
    {
      'icon': Icons.phone_outlined,
      'title': 'Call Us',
      'subtitle': '+212 5XX-XXXXXX',
      'action': 'tel:+2125XXXXXXXX',
    },
    {
      'icon': Icons.chat_bubble_outline,
      'title': 'Live Chat',
      'subtitle': 'Available 9 AM - 9 PM',
      'action': 'chat',
    },
    {
      'icon': Icons.location_on_outlined,
      'title': 'Visit Us',
      'subtitle': 'Casablanca, Morocco',
      'action': 'location',
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
          icon: Icon(Icons.arrow_back_ios, color: TColor.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
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
            // Header Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TColor.primary, TColor.primaryText.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions or contact our support team',
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Contact Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Contact Us',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ...contactOptions.map((option) => _buildContactOption(option)),

            const SizedBox(height: 30),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // FAQ Accordion
            ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  faqList[index]['isExpanded'] = !isExpanded;
                });
              },
              children: faqList.map<ExpansionPanel>((faq) {
                return ExpansionPanel(
                  backgroundColor: TColor.white,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        faq['question'],
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer'],
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  isExpanded: faq['isExpanded'],
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Additional Help Section
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
                  Text(
                    'Still need help?',
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Our support team is available 7 days a week from 9 AM to 9 PM. We typically respond within 2 hours.',
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to inbox/messages
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Send us a message',
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(Map<String, dynamic> option) {
    return InkWell(
      onTap: () {
        // Handle different actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${option['title']}...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: TColor.textfield,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                option['icon'],
                color: TColor.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['title'],
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option['subtitle'],
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: TColor.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
