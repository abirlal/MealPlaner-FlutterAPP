// /lib/screens/orders_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealPlanner/models/itemOrder_model.dart';

import 'package:mealPlanner/services/foodOrder_service.dart';
import 'package:mealPlanner/widgets/BottomNavBarWidget.dart';



class OrdersScreenPage extends StatefulWidget {
  @override
  _OrdersScreenPageState createState() => _OrdersScreenPageState();
}

class _OrdersScreenPageState extends State<OrdersScreenPage> {
  final OrderService orderService = OrderService();
  late Future<List<FoodOrder>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = orderService.fetchOrders(); // Fetch orders on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: const Color.fromARGB(255, 95, 147, 245),
      ),
      body: FutureBuilder<List<FoodOrder>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!; // Retrieve the list of orders

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16.0), // Space between tiles
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0), // Remove margin for the card itself
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${order.orderId}', // Corrected to use orderId
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Order Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDateTime)}',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                      subtitle: Text('Total Amount: ₹${order.grandTotal.toStringAsFixed(2)}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: order.items.length,
                                itemBuilder: (context, itemIndex) {
                                  final item = order.items[itemIndex];
                                  return ListTile(
                                    leading: Image.asset(
                                      'assets/images/popular_foods/${item.productImage}.png',
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(item.productName),
                                    subtitle: Text('Qty: ${item.quantity}\nPrice: ₹${item.productPrice.toStringAsFixed(2)}'),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/qrCode', arguments: {
                                    'order_id': order.orderId,
                                    'total_amount': order.grandTotal,
                                    'no_of_items': order.numberOfItems,
                                    'item_name': order.items.isNotEmpty ? order.items[0].productName : '',
                                    'delivery_date': DateFormat('dd/MM/yyyy HH:mm').format(order.deliveryTime),
                                  });
                                },
                                child: Text('Get QR'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}


/*

class OrdersScreenPage extends StatefulWidget {
  @override
  _OrdersScreenPageState createState() => _OrdersScreenPageState();
}

class _OrdersScreenPageState extends State<OrdersScreenPage> {
  final OrderService orderService  = OrderService();
  late Future<List<FoodOrder>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = orderService.fetchOrders(); // Replace with actual user ID
  }
  // Sample data for multiple orders
  final List<FoodOrder> orders = [
    FoodOrder(
      orderId: 1,
      userId: 1,
      orderDateTime: DateTime.now().subtract(Duration(days: 1)),
      deliveryTime: DateTime.now().subtract(Duration(days: 1)),
      grandTotal: 580.0,
      numberOfItems: 3,
      items: [
        OrderedItem(
          id: 1,
          productName: 'Veg Pizza',
          productImage: 'ic_popular_food_1',
          productPrice: 250.0,
          quantity: 2,
          //totalPrice: 44.00,
          sgst: 0.06,
          cgst: 0.06,
        ),
        OrderedItem(
          id: 2,
          productName: 'Pasta',
          productImage: 'ic_popular_food_2',
          productPrice: 150.0,
          quantity: 1,
          //totalPrice: 44.00,
          sgst: 0.06,
          cgst: 0.06,
        ),
      ],
    ),
    FoodOrder(
      orderId: 2,
      userId: 2,
      orderDateTime: DateTime.now(),
      grandTotal: 300.0,
      numberOfItems: 2,
      deliveryTime:DateTime.now(),
      items: [
        OrderedItem(
          id: 3,
          productName: 'Salad',
          productImage: 'ic_popular_food_3',
          productPrice: 100.0,
          quantity: 3,
          //totalPrice: 44.00,
          sgst: 0.06,
          cgst: 0.06,
        ),
        OrderedItem(
          id: 4,
          productName: 'Garlic Bread',
          productImage: 'ic_popular_food_4',
          productPrice: 50.0,
          quantity: 2,
          //totalPrice: 44.00,
          sgst: 0.06,
          cgst: 0.06,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: const Color.fromARGB(255, 95, 147, 245),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16.0), // Add space between tiles
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5), // Blue shadow color
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3), // Changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(0), // Remove margin for the card itself
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${order.userId}',
                        style: TextStyle(
                          color: Colors.blue[800], // Dark blue color
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      Text(
                        'Order Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDateTime)}',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16), // Regular text color
                      ),
                    ],
                  ),
                  subtitle: Text('Total Amount: ₹${order.grandTotal.toStringAsFixed(2)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = order.items[itemIndex];
                              return ListTile(
                                leading: Image.asset(
                                  'assets/images/popular_foods/' + item.productImage + ".png", // Update with your actual image URL
                                  fit: BoxFit.cover,
                                ),
                                title: Text(item.productName),
                                subtitle: Text('Qty: ${item.quantity}\nPrice: ₹${item.productPrice.toStringAsFixed(2)}'),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => {
                              Navigator.pushReplacementNamed(context, '/qrCode',
                                arguments: {
                                  'order_id': 0,
                                  'total_amount': order.grandTotal,
                                  'no_of_items': order.numberOfItems,
                                  'item_name': order.items[0].productName,
                                  'delivery_date':  DateFormat('dd/MM/yyyy HH:mm').format(order.deliveryTime),
                                },
                               ),
                            },
                            child: Text('Get QR'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}
*/