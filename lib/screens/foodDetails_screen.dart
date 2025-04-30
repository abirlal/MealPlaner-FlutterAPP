// lib/pages/food_details_page.dart

import 'package:flutter/material.dart';

import 'package:mealPlanner/config/global_variables.dart';
import 'package:mealPlanner/services/alert_service.dart';
import 'package:mealPlanner/services/foodItem_service.dart';
import 'package:mealPlanner/models/foodItem_model.dart';
import 'package:mealPlanner/widgets/BottomNavBarWidget.dart';



class FoodDetailsPage extends StatefulWidget {
  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  late Future<FoodItem> foodItem;
  final FoodItemService _foodItemService = FoodItemService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      int itemId = arguments['item_id'];
      foodItem = _foodItemService.fetchFoodItem(itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 1, 25, 142),
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.business_center,
                color: Color.fromARGB(255, 2, 16, 143),
              ),
              onPressed: () {
                // Uncomment when ready to use
                //Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
                
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              labelColor: Color.fromARGB(255, 7, 50, 243),
              indicatorColor: Color.fromARGB(255, 7, 50, 243),
              unselectedLabelColor: Color(0xFFa4a1a1),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: 'Food Details'),
                Tab(text: 'Food Reviews'),
              ],
            ),
          ),
        ),
        body: FutureBuilder<FoodItem>(
          future: foodItem,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            }

            final foodItem = snapshot.data!;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                          'assets/images/popular_foods/' + foodItem.imageUrl + ".png", // Update with your actual image URL
                      fit: BoxFit.cover,
                    ),
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    elevation: 1,
                    margin: EdgeInsets.all(5),
                  ),
                  SizedBox(height: 15),
                  FoodTitleWidget(
                    productName: foodItem.name,
                    productPrice: '\₹ ${foodItem.price.toStringAsFixed(2)}',
                    productHost: foodItem.vendorName,
                  ),
                  SizedBox(height: 15),
                  AddToCartMenu(foodItem: foodItem),
                  SizedBox(height: 15),
                  Expanded(
                    child: TabBarView(
                      children: [
                        DetailContentMenu(foodItem: foodItem),
                        DetailContentMenu(foodItem: foodItem),
                      ],
                    ),
                  ),
                  //BottomMenu(),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavBarWidget(),
      ),
    );
  }
}

class FoodTitleWidget extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productHost;

  FoodTitleWidget({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              productName,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 2, 24, 225),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              productPrice,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 2, 24, 225),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Text(
              "by ",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFa9a9a9),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              productHost,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 2, 24, 225),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DetailContentMenu extends StatelessWidget {
  final FoodItem foodItem;

  DetailContentMenu({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    // Split the description by comma and trim any extra whitespace
    List<String> items = foodItem.description.split(',').map((item) => item.trim()).toList();

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create a bullet point list
          for (var item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.black), // Bullet point
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}




class AddToCartMenu extends StatelessWidget {
  final FoodItem foodItem;

  AddToCartMenu({required this.foodItem});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.remove),
          //   color: Colors.black,
          //   iconSize: 30,
          // ),
          InkWell(
            onTap: () {
              if (GlobalVariables.cart_items.length == 1) {
                // There is only one entry in the orders list
                print("There is exactly one order.");
                AlertService.showAlert(
                  context: context,
                  title: 'Alert',
                  message: 'Already one item added in cart.. !!',
                  buttonText: 'OK',
                  onButtonPressed: () {
                    // Add any action you want to perform on button press
                    //print('OK button pressed');
                  },
                );
              } else {
                Navigator.pushReplacementNamed(context, '/foodCartDetails',
                  arguments: {
                    'item_id': foodItem.id,
                    'item_name': foodItem.name,
                    'item_price': foodItem.price,
                    'item_image': foodItem.imageUrl,
                     // Pass the item ID
                      // Add any other parameters if needed
                  });
              }

            },
            child: Container(
              width: 200.0,
              height: 45.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 235, 1, 1),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Add in Your Meal',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.add),
          //   color: Color(0xFFfd2c2c),
          //   iconSize: 30,
          // ),
        ],
      ),
    );
  }
}


