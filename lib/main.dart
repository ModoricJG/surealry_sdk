import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_screen.dart';
import 'package:surearly_smart_sdk/features/ble/screens/start_screen.dart';
import 'package:surearly_smart_sdk/observers.dart';

void main() async {
  await MyApp.initializeLocalNotifications();
  runApp(ProviderScope(
    observers: [
      Observers(),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: AppConfigs.progressNotificationChannelKey,
              channelName: AppConfigs.progressNotificationChannelName ,
              channelDescription: '테스트 진행률 표시',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple),

          NotificationChannel(
              channelKey: AppConfigs.testCompleteNotificationChannelKey,
              channelName: AppConfigs.testCompleteNotificationChannelName ,
              channelDescription: '테스트 완료',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);
    // Get initial notification action is optional
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      onGenerateRoute: generateRoute,
    );
  }

  final routes = {
    HomeScreen.route: (context) => const HomeScreen(),
    StartScreen.route: (context) => const StartScreen(),
  };

  Route? generateRoute(RouteSettings routeSettings) {
    String? route;
    if (routeSettings.name != null) {
      var uriData = Uri.parse(routeSettings.name!);
      route = uriData.path;
    }
    return MaterialPageRoute(
      builder: (context) {
        switch (route) {
          case HomeScreen.route:
            return const HomeScreen();
          default:
            ///TODO 모듈로 사용할 경우 주석 해제 (StartScreen 으로 변경해야 모듈 동작함)
            return const StartScreen();
            // return const HomeScreen();
        }
      },
      settings: routeSettings,
    );
  }

}