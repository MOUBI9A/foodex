import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/widgets/tab_button.dart';

import '../home/home_view.dart';
import '../menu/menu_view.dart';
import '../more/more_view.dart';
import '../offer/offer_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selctTab != 2) {
              selctTab = 2;
              selectPageView = const HomeView();
            }
            if (mounted) {
              setState(() {});
            }
          },
          shape: const CircleBorder(),
          backgroundColor: selctTab == 2 ? TColor.primary : TColor.placeholder,
          child: Image.asset(
            "assets/images/tab_home.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomAppBar(
            color: Colors.white.withOpacity(0.9),
            elevation: 0,
            notchMargin: 12,
            height: 70,
            shape: const CircularNotchedRectangle(),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TabButton(
                      title: "Menu",
                      icon: "assets/images/tab_menu.png",
                      onTap: () {
                        if (selctTab != 0) {
                          selctTab = 0;
                          selectPageView = const MenuView();
                        }
                        if (mounted) setState(() {});
                      },
                      isSelected: selctTab == 0),
                  TabButton(
                      title: "Offer",
                      icon: "assets/images/tab_offer.png",
                      onTap: () {
                        if (selctTab != 1) {
                          selctTab = 1;
                          selectPageView = const OfferView();
                        }
                        if (mounted) setState(() {});
                      },
                      isSelected: selctTab == 1),
                  const SizedBox(width: 40),
                  TabButton(
                      title: "Profile",
                      icon: "assets/images/tab_profile.png",
                      onTap: () {
                        if (selctTab != 3) {
                          selctTab = 3;
                          selectPageView = const ProfileView();
                        }
                        if (mounted) setState(() {});
                      },
                      isSelected: selctTab == 3),
                  TabButton(
                      title: "More",
                      icon: "assets/images/tab_more.png",
                      onTap: () {
                        if (selctTab != 4) {
                          selctTab = 4;
                          selectPageView = const MoreView();
                        }
                        if (mounted) setState(() {});
                      },
                      isSelected: selctTab == 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
