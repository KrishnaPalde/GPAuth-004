import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gpauth_004/Models/Color.dart';
import 'package:gpauth_004/Screens/dashboard_screen.dart';
import 'package:gpauth_004/Screens/login_screen.dart';
import 'package:gpauth_004/Screens/register_screen.dart';
import 'package:gpauth_004/firebase_options.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPAuth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          inputDecorationTheme: FilledOrOutlinedTextTheme(
        radius: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        errorStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        fillColor: MaterialColor(0xE2F0F9, color),
        prefixIconColor: Colors.green,
        enabledColor: Colors.grey,
        focusedColor: Colors.green,
        floatingLabelStyle: const TextStyle(color: Colors.green),
        width: 1.5,
        labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
      )),
      home: LoginScreen(),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
      },
    );
  }
}
