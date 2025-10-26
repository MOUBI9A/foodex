import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/core/utils/locator.dart';
import 'package:food_delivery/core/constants/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/my_http_overrides.dart';
import 'core/services/local_db_service.dart';

SharedPreferences? prefs;
void main() async {
  setUpLocator();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  
  // Initialize Hive for offline-first persistence
  await LocalDbService.init();

  runApp(const ProviderScope(child: FoodExApp()));
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.yellow
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

class FoodExApp extends StatelessWidget {
  const FoodExApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FOODEx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: goRouter,
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
