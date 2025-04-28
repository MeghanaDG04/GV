import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/map_content_wrapper.dart';
//import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'providers/admin_provider.dart';
import 'package:flutter_application_1/screens/about_screen.dart';
import 'package:flutter_application_1/screens/contact_screen.dart';
import 'package:flutter_application_1/screens/help_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/user_settings_screen.dart';
import 'package:flutter_application_1/screens/admin/admin_dashboard.dart';
import 'package:flutter_application_1/screens/admin/location_management.dart';
import 'package:flutter_application_1/screens/admin/product_management.dart';
import 'package:flutter_application_1/screens/admin/service_management.dart';
import 'package:flutter_application_1/screens/admin/store_management.dart';
//import 'package:flutter_application_1/models/booking.dart';
//import 'package:flutter_application_1/screens/booking_confirmation_screen.dart';
import 'package:flutter_application_1/screens/map_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        // Add other providers here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Volt',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin-dashboard': (context) => AdminDashboard(),
        '/user_settings_screen': (context) => const UserSettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/help': (context) => const HelpScreen(),
        '/contact': (context) => const ContactScreen(),
        '/location_management': (context) => LocationManagement(),
        '/product_management': (context) => ProductManagement(),
        '/service_management': (context) => ServiceManagement(),
        '/store_management': (context) => StoreManagement(),
        '/map': (context) => const MapContentWrapper(),
        //'/settings': (context) => SettingsScreen(),
        //'/booking': (context) => const Booking(),
        // '/booking_confirmation': (context) => BookingConfirmationScreen(),
      },    
    );
  }
}