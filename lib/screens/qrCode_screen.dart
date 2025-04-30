import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealPlanner/widgets/BottomNavBarWidget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  late int orderId; 
  late double totalAmount; 
  late int noOfItems;
  late String itemName; // Add item namec
  late String deliveryDate; // Add delivery date

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      orderId = arguments['order_id'];
      totalAmount = arguments['total_amount'];
      noOfItems = arguments['no_of_items'];
      itemName = arguments['item_name']; // Get item name from arguments
      deliveryDate = arguments['delivery_date']; // Get delivery date from arguments
    } else {
      orderId = 0; // Default value
      totalAmount = 0.0; // Default value
      noOfItems = 0; // Default value
      itemName = ""; // Default value
      deliveryDate = ""; // Default value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 147, 245),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Center(
          child: Text(
            "Order QR Code",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Show this QR Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                QrImageView(
                  data: "OID:$orderId, iNo:$noOfItems, Amount: ₹${totalAmount.toStringAsFixed(2)}",
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          'Uh oh! Something went wrong...',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                // Display the order details
                Text("Order ID: $orderId",style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
                Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}",style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
                Text("No of Items: $noOfItems",style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
                Text("Items: $itemName",style: TextStyle(fontSize: 20),textAlign: TextAlign.left),                
                Text("Delivery ETA: $deliveryDate",style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}
