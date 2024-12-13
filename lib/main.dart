import 'package:ecommerce_app/screens/bottom_nav_bar_screen.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/screens/homie_screen.dart';
import 'package:ecommerce_app/screens/orders_detail_screen.dart';
import 'package:ecommerce_app/screens/orders_screen.dart';
import 'package:ecommerce_app/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'models/user_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: AppTheme.lightTheme,
      // Use a FutureBuilder or Consumer to determine the initial route
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authStateProvider);

          return authState.when(
            //loading: () => SplashScreen(),
            loading: () => const Center(child: CircularProgressIndicator()), // Show loading indicator while checking authentication
            data: (user) {
              if (user != null) {
                // If the user is logged in, navigate to HomeScreen
                return BottomNavBarScreen();
              } else {
                // If the user is not logged in, navigate to LoginScreen
                return LoginScreen();
              }
            },
            error: (error, stackTrace) => Scaffold(
              body: Center(
                child: Text('Error: $error'),
              ),
            ),
          );
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
        '/orders': (context) => OrdersScreen(),
        '/order-details': (context) => OrderDetailsScreen(),
        '/bottomnav': (context) => BottomNavBarScreen(),
        '/user': (context) => UserProfileScreen(),
        '/homie': (context) => HomieScreen(),
      },
    );
  }
}




/*import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/screens/orders_detail_screen.dart';
import 'package:ecommerce_app/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'models/user_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: AppTheme.lightTheme,
      // Use a FutureBuilder or Consumer to determine the initial route
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authStateProvider);

          return authState.when(
            loading: () => const Center(child: CircularProgressIndicator()), // Show loading indicator while checking authentication
            data: (user) {
              if (user != null) {
                // If the user is logged in, navigate to HomeScreen
                return HomeScreen();
              } else {
                // If the user is not logged in, navigate to LoginScreen
                return LoginScreen();
              }
            },
            error: (error, stackTrace) => Scaffold(
              body: Center(
                child: Text('Error: $error'),
              ),
            ),
          );
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
        '/orders': (context) => OrdersScreen(),
        '/order-details': (context) => OrderDetailsScreen(),
      },
    );
  }
}*/
