import 'package:flutter/material.dart';
import 'package:mitti_bot/src/router_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class FreemanApp extends StatelessWidget {
  const FreemanApp({super.key});


  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: "Saas",
      theme: ThemeData(
        fontFamily: 'Manrope',
      ),
      navigatorKey: navigatorKey,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
    );
  }
}
