import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mealPlanner/config/global_variables.dart';
import 'package:mealPlanner/models/itemOrder_model.dart';
import 'package:mealPlanner/services/alert_service.dart';
import 'package:mealPlanner/services/foodOrder_service.dart';
import 'package:mealPlanner/widgets/BottomNavBarWidget.dart';

class DummyPaymentPage extends StatefulWidget {
  @override
  _DummyPaymentPageState createState() => _DummyPaymentPageState();
}

class _DummyPaymentPageState extends State<DummyPaymentPage> {
  late double amount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      amount = arguments['order_total_amount'];
    } else {
      amount = 0.0; // Default value if no arguments are passed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 147, 245),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3a3737)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        
        title: const Center(
          child: Text(
            "Dummy Payments",
            style: TextStyle(color: Color(0xFF3a3737), fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark, 
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Amount for Payment",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                "₹${amount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.green),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Simulate a successful payment
                  _simulatePaymentSuccess(context);
                },
                child: Text("Pay Now (Dummy)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }

  Future<void> _simulatePaymentSuccess(BuildContext context) async {
  
    FoodOrder foodOrder = FoodOrder(
      orderId: 0,
      userId: GlobalVariables.profileId, 
      orderDateTime: DateTime.now(),
      grandTotal: amount, 
      numberOfItems: GlobalVariables.cart_items.length,
      items: GlobalVariables.cart_items,
      deliveryTime: DateTime.now().add(Duration(hours: 12)),
    );
    bool isSuccess = false;
    int orderId = 0; 
    double totalAmount = 0.00;
    int noOfItems = 0;
    String itemNames = "" ;
    String deliveryDate = ""; //DateFormat('yyyy-MM-dd').format(foodOrder.deliveryTime)
    try {
      final orderService = OrderService();
      final createdOrder = await orderService.createOrder(foodOrder);
      if (createdOrder != null){
        isSuccess = true;
        orderId = createdOrder.orderId;
        totalAmount = createdOrder.grandTotal;
        noOfItems = createdOrder.numberOfItems;
        itemNames="";
        for (var item in createdOrder.items) {
          itemNames += "${item.productName},";
        }
        deliveryDate = DateFormat('dd-MM-yyyy hh:mm').format(createdOrder.deliveryTime);
      }
    } catch (e) {
      // Handle error
      print("Error: $e");
    }
    
    // Check if the order creation was successful
    if (isSuccess) {
      // Navigate to the QR Code page if the order was successful
      Navigator.pushReplacementNamed(context, '/qrCode', arguments: {
        'order_id': orderId, // Use the actual order ID from the response
        'total_amount': totalAmount,
        'no_of_items': noOfItems,
        'item_name': itemNames,
        'delivery_date': deliveryDate, // Format delivery date
      });
    } else {
      // Show an alert if the order was not created successfully
      AlertService.showAlert(
        context: context,
        title: 'Error',
        message: 'Order was not created. Please try again later.',
        buttonText: 'OK',
        onButtonPressed: () {
          // Handle the button press (e.g., log an event or dismiss the alert)
        },
      );
    }
  }

}












  