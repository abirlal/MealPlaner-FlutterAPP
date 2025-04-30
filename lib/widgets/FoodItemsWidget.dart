// /lib/widgets/FoodItemsWidget.dart

import 'package:flutter/material.dart';
import 'package:mealPlanner/models/foodItem_model.dart';
import 'package:mealPlanner/services/foodItem_service.dart';

class FoodItemsWidget extends StatefulWidget {
  final String menuId; // Accept the menu ID as a parameter

  const FoodItemsWidget({super.key, required this.menuId});

  @override
  _FoodItemsWidgetState createState() => _FoodItemsWidgetState(menuId);
}

class _FoodItemsWidgetState extends State<FoodItemsWidget> {
  late Future<List<FoodItem>> _foodItemsFuture;
  final String menuId; // Store the menu ID

  _FoodItemsWidgetState(this.menuId);

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  void _loadFoodItems() {
    _foodItemsFuture = FoodItemService().fetchFoodItems(widget.menuId);
  }
  @override
  void didUpdateWidget(covariant FoodItemsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.menuId != oldWidget.menuId) {
      _loadFoodItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          //ItemTitle(onRefresh: _loadFoodItems),
          ItemTitle(onRefresh: () {
            // Optionally handle refresh within FoodItemsWidget
            setState(() {
              _loadFoodItems();
            });
          }),
          Expanded(
            child: Items(foodItemsFuture: _foodItemsFuture),
          ),
        ],
      ),
    );
  }
}


class ItemTiles extends StatelessWidget {
  final int id;
  final String name;
  final String highlight;
  final String imageUrl;
  final String rating;
  final String numberOfRating;
  final double price; // Ensure type consistency
  final String slug;
  final String vendorName;

  ItemTiles({
    Key? key,
    required this.id,
    required this.name,
    required this.highlight,
    required this.imageUrl,
    required this.rating,
    required this.numberOfRating,
    required this.price,
    required this.slug,
    required this.vendorName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/foodDetails',
        arguments: {
            'item_id': id, // Pass the item ID
            // Add any other parameters if needed
          });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 133, 197, 246),
                  blurRadius: 15.0,
                  offset: Offset(0, 0.75),
                ),
              ],
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 5, top: 5),
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white70,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 133, 197, 246),
                                  blurRadius: 25.0,
                                  offset: Offset(0.0, 0.75),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Color.fromARGB(255, 245, 4, 28),
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/popular_foods/' + imageUrl + ".png",
                          width: 130,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            color: Color(0xFF6e6e71),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '\₹' + price.toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 244, 7, 7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star, size: 16, color: Color.fromARGB(255, 252, 8, 8)),
                                Text(
                                  rating,
                                  style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "($numberOfRating)",
                                  style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'By: ' + vendorName,
                          style: TextStyle(
                            color: Color.fromARGB(255, 40, 50, 237),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ItemTitle extends StatelessWidget {
  final VoidCallback onRefresh;

  ItemTitle({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Popular Foods",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF3a3a3b),
              fontWeight: FontWeight.w300,
            ),
          ),
          TextButton(
            onPressed: onRefresh,
            child: Text(
              "Refresh",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Items extends StatelessWidget {
  final Future<List<FoodItem>> foodItemsFuture;

  const Items({Key? key, required this.foodItemsFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FoodItem>>(
      future: foodItemsFuture, // Use the passed future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No food items available.'));
        } else {
          final foodItems = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10.0, // Horizontal spacing
              mainAxisSpacing: 10.0, // Vertical spacing
              childAspectRatio: 0.7, // Aspect ratio of each tile
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              return ItemTiles(
                id: item.id,
                name: item.name,
                highlight: item.highlight,
                imageUrl: item.imageUrl,
                rating: item.rating.toString(),
                numberOfRating: item.numberOfRating.toString(),
                price: item.price, // Ensure this is a double
                slug: item.slug,
                vendorName: item.vendorName,
              );
            },
          );
        }
      },
    );
  }
}


/*class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 265,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ItemTitle(),
          Expanded(
            child: Items(),
          )
        ],
      ),
    );
  }
}

class ItemTiles extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final String rating;
  final String numberOfRating;
  final String price;
  final String slug;
  final String providedBy;


  ItemTiles({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.numberOfRating,
    required this.price,
    required this.slug,
    required this.providedBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, ScaleRoute(page: FoodDetailsPage()));
        Navigator.pushReplacementNamed(context, '/foodDetails');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 133, 197, 246),
                  blurRadius: 15.0,
                  offset: Offset(0, 0.75),
                ),
              ],
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 5, top: 5),
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white70,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 133, 197, 246),
                                  blurRadius: 25.0,
                                  offset: Offset(0.0, 0.75),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Color.fromARGB(255, 245, 4, 28),
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/popular_foods/' + imageUrl + ".png",
                          width: 130,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            color: Color(0xFF6e6e71),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '\₹' + price,
                              style: TextStyle(
                                color: Color.fromARGB(255, 244, 7, 7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star, size: 16, color: Color.fromARGB(255, 252, 8, 8)),
                                Text(
                                  rating,
                                  style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "($numberOfRating)",
                                  style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                              'By: ' + providedBy,
                              style: TextStyle(
                                color: Color.fromARGB(255, 40, 50, 237),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Popular Foods",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF3a3a3b),
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            "See all",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 10.0, // Horizontal spacing
        mainAxisSpacing: 10.0, // Vertical spacing
        childAspectRatio: 0.7, // Aspect ratio of each tile
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: 12, // Number of items (you can dynamically set this based on your data)
      itemBuilder: (context, index) {
        List<Map<String, String>> foodItems = [
          {"id":"1", "name": "Regular Veg", "imageUrl": "ic_popular_food_1", "rating": "4.9", "numberOfRating": "200", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"2", "name": "Regular Fish", "imageUrl": "ic_popular_food_3", "rating": "4.9", "numberOfRating": "100", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"3", "name": "Regular Chicken", "imageUrl": "ic_popular_food_3", "rating": "4.9", "numberOfRating": "100", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"4", "name": "Regular Egg", "imageUrl": "ic_popular_food_4", "rating": "4.0", "numberOfRating": "50", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"5", "name": "Combo Veg", "imageUrl": "ic_popular_food_5", "rating": "4.00", "numberOfRating": "100", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"6", "name": "Combo Non-Veg", "imageUrl": "ic_popular_food_2", "rating": "4.6", "numberOfRating": "150", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"7", "name": "Veg Biriyani ", "imageUrl": "ic_popular_food_2", "rating": "4.6", "numberOfRating": "150", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"8", "name": "Chicken Biriyani", "imageUrl": "ic_popular_food_2", "rating": "4.6", "numberOfRating": "150", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"9", "name": "Healthy Food A", "imageUrl": "ic_popular_food_5", "rating": "4.00", "numberOfRating": "100", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"10", "name": "Healthy Food B", "imageUrl": "ic_popular_food_6", "rating": "4.2", "numberOfRating": "70", "price": "44.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"11", "name": "Special Veg", "imageUrl": "ic_popular_food_1", "rating": "4.9", "numberOfRating": "200", "price": "120.00", "slug": "", "providedBy": "Aveenandan Caterer"},
          {"id":"12", "name": "Special Non-Veg", "imageUrl": "ic_popular_food_2", "rating": "4.6", "numberOfRating": "150", "price": "120.00", "slug": "", "providedBy": "Aveenandan Caterer"},
        ];

        return ItemTiles(
          id: int.parse(foodItems[index]["id"]!),
          name: foodItems[index]["name"]!,
          imageUrl: foodItems[index]["imageUrl"]!,
          rating: foodItems[index]["rating"]!,
          numberOfRating: foodItems[index]["numberOfRating"]!,
          price: foodItems[index]["price"]!,
          slug: foodItems[index]["slug"]!,
          providedBy: foodItems[index]["providedBy"]!,

        );
      },
    );
  }
}
*/



