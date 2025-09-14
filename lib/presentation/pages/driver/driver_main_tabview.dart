import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/pages/driver/driver_home_view.dart';
import 'package:food_delivery/presentation/pages/driver/driver_orders_view.dart';
import 'package:food_delivery/presentation/pages/driver/driver_earnings_view.dart';
import 'package:food_delivery/presentation/pages/driver/driver_profile_view.dart';
import '../../../../widgets/tab_button.dart';

class DriverMainTabView extends StatefulWidget {
  const DriverMainTabView({super.key});

  @override
  State<DriverMainTabView> createState() => _DriverMainTabViewState();
}

class _DriverMainTabViewState extends State<DriverMainTabView> {
  int selectTab = 0;
  PageController controller = PageController();

  List<Widget> get pages => [
        const DriverHomeView(),
        const DriverOrdersView(),
        const DriverEarningsView(),
        const DriverProfileView(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selectTab = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                  title: "Home",
                  icon: "assets/img/tab_home.png",
                  onTap: () {
                    setState(() {
                      selectTab = 0;
                    });
                    controller.animateToPage(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut);
                  },
                  isSelected: selectTab == 0,
                ),
                TabButton(
                  title: "Orders",
                  icon: "assets/img/more_my_order.png",
                  onTap: () {
                    setState(() {
                      selectTab = 1;
                    });
                    controller.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut);
                  },
                  isSelected: selectTab == 1,
                ),
                TabButton(
                  title: "Earnings",
                  icon: "assets/img/more_payment.png",
                  onTap: () {
                    setState(() {
                      selectTab = 2;
                    });
                    controller.animateToPage(2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut);
                  },
                  isSelected: selectTab == 2,
                ),
                TabButton(
                  title: "Profile",
                  icon: "assets/img/tab_profile.png",
                  onTap: () {
                    setState(() {
                      selectTab = 3;
                    });
                    controller.animateToPage(3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut);
                  },
                  isSelected: selectTab == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
