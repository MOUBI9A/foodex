import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/pages/login/login_view.dart';
import 'package:food_delivery/presentation/pages/more/more_view.dart';
import 'package:food_delivery/presentation/pages/wallet/wallet_view.dart';
import 'package:food_delivery/presentation/pages/more/my_order_view.dart';
import 'package:food_delivery/core/network/service_call.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text('My Wallet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyOrderView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.more_horiz),
            title: const Text('More'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoreView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              ServiceCall.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
//toto