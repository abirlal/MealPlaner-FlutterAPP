// /lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:mealPlanner/widgets/TopMenus.dart';
import 'package:mealPlanner/widgets/SearchWidget.dart';

import 'package:mealPlanner/widgets/FoodItemsWidget.dart';
import 'package:mealPlanner/widgets/BottomNavBarWidget.dart';
import 'package:mealPlanner/config/global_variables.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//class HomePage extends State {
  String _currentMenuId = '0'; // Default menu ID
  void _updateMenuId(String menuId) {
    setState(() {
      _currentMenuId = menuId; // Update menuId and trigger rebuild
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "Hello ${GlobalVariables.profileFirstName} ...!!, What would you like to eat?",
          style: TextStyle(
              color: Color.fromARGB(255, 1, 1, 122),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        //brightness:Brightness.light,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Color(0xFF3a3737),
              ),
              onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchWidget(),
            TopMenus(onMenuItemSelected: _updateMenuId),
            //TopMenus(),
            FoodItemsWidget(menuId: _currentMenuId),
            //ItemsWidget(),
            //BestFoodWidget(),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}

