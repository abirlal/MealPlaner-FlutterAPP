import 'package:flutter/material.dart';
import 'package:mealPlanner/screens/foodCart_screen.dart';
import 'package:mealPlanner/screens/orders_screen.dart';
import 'package:mealPlanner/screens/payment_screen.dart';
import 'package:mealPlanner/screens/qrCode_screen.dart';
import 'package:mealPlanner/screens/splash_screen.dart';
import 'package:mealPlanner/screens/login_screen.dart';
import 'package:mealPlanner/screens/register_screen.dart';
import 'package:mealPlanner/screens/home_screen.dart';
import 'package:mealPlanner/screens/foodDetails_screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.blueAccent, // Accent color
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blueGrey, // Buttons use blue color
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blue[802], // AppBar uses blue color
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.blue[800]), // Custom text color
        ),
      ),
      
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreenPage(),
        '/home': (context) => HomePage(),
        '/foodDetails': (context) => FoodDetailsPage(),
        '/foodCartDetails': (context) => FoodCartPage(),
        '/payments': (context) => DummyPaymentPage(),
        '/orders': (context) => OrdersScreenPage(),
        '/qrCode': (context) => QRCodeScreen(), 
        
      },
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
