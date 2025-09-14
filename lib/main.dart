import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/core/utils/locator.dart';
// import 'package:food_delivery/core/service_call.dart';  // Commented for bypass
import 'package:food_delivery/presentation/pages/login/welcome_view.dart'; // Needed for routing
import 'package:food_delivery/presentation/pages/main_tabview/main_tabview.dart';
import 'package:food_delivery/presentation/pages/user_type_selector_view.dart';
// import 'package:food_delivery/presentation/pages/on_boarding/startup_view.dart';  // Commented for bypass
import 'package:shared_preferences/shared_preferences.dart';

// import 'common/globs.dart';  // Commented for bypass
import 'core/network/my_http_overrides.dart';

SharedPreferences? prefs;
void main() async {
  setUpLocator();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  // Bypass authentication for testing
  // if(Globs.udValueBool(Globs.userLogin)) {
  //   ServiceCall.userPayload = Globs.udValue(Globs.userPayload);
  // }

  // Go directly to user type selector for testing (bypass authentication)
  runApp(const MyApp(
    defaultHome: UserTypeSelectorView(),
  ));
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

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodEx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: widget.defaultHome,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case "welcome":
            return MaterialPageRoute(builder: (context) => const WelcomeView());
          case "Home":
            return MaterialPageRoute(builder: (context) => const MainTabView());
          default:
            return MaterialPageRoute(
                builder: (context) => Scaffold(
                      body: Center(
                          child: Text("No path for ${routeSettings.name}")),
                    ));
        }
      },
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
