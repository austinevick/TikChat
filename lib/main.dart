import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/utils.dart';
import 'notification_config.dart';
import 'screen/bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpOneSignal();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: const Color(0xff292d36),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xff11162a))),
        navigatorKey: navigatorKey,
        home: const BottomNavigationBarScreen(),
      ),
    );
  }
}
