// /lib/widgets/TopMenus.dart

import 'package:flutter/material.dart';
import 'package:mealPlanner/models/menu_model.dart';
import 'package:mealPlanner/services/menu_service.dart';
import 'package:mealPlanner/services/alert_service.dart';

class TopMenus extends StatefulWidget {
  final Function(String) onMenuItemSelected;

  const TopMenus({Key? key, required this.onMenuItemSelected}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TopMenusState createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {
  late Future<List<MenuItem>> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = MenuService().fetchMenuItems();
  }

  void _onMenuItemTap(String id) {
    // AlertService.showAlert(
    //   context: context,
    //   title: "Alert",
    //   message: "Menu item with ID $id tapped",
    //   buttonText: "OK"
    // );
    widget.onMenuItemSelected(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: FutureBuilder<List<MenuItem>>(
        future: _menuItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No menu items available'));
          }

          final menuItems = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return TopMenuTile(
                id: item.menuId.toString(),
                name: item.menuName, //.replaceAll("\\n", "\n"), // Handle newline characters
                imageUrl: item.menuImageUrl, // Adjust based on image naming
                slug: item.menuType.toLowerCase(),
                onTap: () => _onMenuItemTap(item.menuId.toString()), // Pass callback
              );
            },
          );
        },
      ),
    );
  }
}



class TopMenuTile extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String slug;
  final VoidCallback onTap; // Callback function for handling tap events

  const TopMenuTile({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.slug,
    required this.onTap, // Initialize the callback
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 133, 197, 246),
                  blurRadius: 25.0,
                  offset: Offset(0.0, 0.75),
                ),
              ],
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Center(
                      child: Image.asset(
                    'assets/images/topmenu/' + imageUrl + ".png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover, // Ensure image fits well
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: Color(0xFF6e6e71),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


/*import 'package:flutter/material.dart';

class TopMenus extends StatefulWidget {
  @override
  _TopMenusState createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          TopMenuTiles(id: "1", name: "Special\nMeal", imageUrl: "ic_special_meal", slug: ""),
          TopMenuTiles(id: "2", name: "Healthy\nMeal", imageUrl: "ic_healthy_meal", slug: ""),
          TopMenuTiles(id: "3", name: "Veg", imageUrl: "ic_veg", slug: ""),
          TopMenuTiles(id: "4", name: "Non-Veg", imageUrl: "ic_nonveg", slug: ""),
          TopMenuTiles(id: "5", name: "Fish", imageUrl: "ic_fish", slug: ""),
          TopMenuTiles(id: "6", name: "Chicken", imageUrl: "ic_chicken", slug: ""),
          TopMenuTiles(id: "7", name: "Egg", imageUrl: "ic_egg", slug: ""),
          TopMenuTiles(id: "8", name: "Mutton", imageUrl: "ic_mutton", slug: ""),
          ],
      ),
    );
  }
}

class TopMenuTiles extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String slug;

  TopMenuTiles(
      {Key? key,
      required this.id,
      required this.name,
      required this.imageUrl,
      required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color.fromARGB(255, 133, 197, 246),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  child: Center(
                      child: Image.asset(
                    'assets/images/topmenu/' + imageUrl + ".png",
                    width: 60,
                    height: 60,
                  )),
                )),
          ),
          Text(name,
              style: TextStyle(
                  color: Color(0xFF6e6e71),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,),
              maxLines: 2, // Limit text to 2 lines
              overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              textAlign: TextAlign.justify, // Justifies the text
              softWrap: true, // Ensure text wraps correctly
          )

        ],
      ),
    );
  }
}
*/