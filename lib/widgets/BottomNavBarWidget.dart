import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mealPlanner/screens/foodCart_screen.dart';
import 'package:mealPlanner/screens/home_screen.dart';
import 'package:mealPlanner/screens/orders_screen.dart';

import 'package:mealPlanner/screens/register_screen.dart';
import 'package:mealPlanner/screens/foodDetails_screen.dart';


class BottomNavBarWidget extends StatefulWidget {
  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    // List of screens to navigate to
    final List<Widget> _screens = [
      HomePage(),
      OrdersScreenPage(),
      FoodCartPage(),
      //AccountScreenPage(),      
      HomePage(),
    ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
//        navigateToScreens(index);
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[_selectedIndex]),
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
         BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home', // Use 'label' instead of 'title'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Orders', // Use 'label' instead of 'title'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart
          ),
          label: 'Cart', // Use 'label' instead of 'title'
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Account', // Use 'label' instead of 'title'
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFFfd5352),
      onTap: _onItemTapped,
    );
  }
}
