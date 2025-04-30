import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealPlanner/widgets/BottomNavBarWidget.dart';
import 'package:mealPlanner/models/itemOrder_model.dart';
import 'package:mealPlanner/config/global_variables.dart';

double grandTotal = 0.0;
class FoodCartPage extends StatefulWidget {
  @override
  _FoodCartPageState createState() => _FoodCartPageState();
}

class _FoodCartPageState extends State<FoodCartPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _addItemToCart(
        id: args['item_id'],
        name: args['item_name'],
        price: args['item_price'],
        image: args['item_image'],
        quantity: 1,
      );
    }
  }

  void _addItemToCart({
    required int id,
    required String name,
    required double price,
    required String image,
    required int quantity,
  }) {
    setState(() {
      
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      bool orderExists = GlobalVariables.cart_items.any((cart_items) => cart_items.id == id);

      if (!orderExists) {
        double totalSGST = price * GlobalVariables.sgst; // SGST for the item
        double totalCGST = price * GlobalVariables.cgst; 
        double totalPrice = price * quantity + totalSGST + totalSGST;
        GlobalVariables.cart_items.add(
          OrderedItem(
            id: id,
            productName: name,
            productPrice: price,
            productImage: image,
            quantity: quantity,
            //totalPrice: totalPrice,
            sgst: totalSGST,
            cgst: totalCGST,
          ),
        );
      } else {
        
      }
    });
  }

  void _deleteOrder(int id) {
   
    setState(() {
      // ignore: avoid_types_as_parameter_names
      GlobalVariables.cart_items.removeWhere((OrderedItem) => OrderedItem.id == id);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3a3737)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Center(
          child: Text(
            "Order Carts",
            style: TextStyle(color: Color(0xFF3a3737), fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[CartIconWithBadge()],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Food Order Cart",
                  style: TextStyle(fontSize: 20, color: Color(0xFF3a3a3b), fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              ...GlobalVariables.cart_items.map((order) => CartItem(
                id: order.id,
                productName: order.productName,
                productPrice: "₹${order.productPrice.toStringAsFixed(2)}", 
                productImage: order.productImage,
                productCartQuantity: order.quantity.toString(),
                onDelete: () => _deleteOrder(order.id),
              )).toList(),
              const SizedBox(height: 10),
              TotalCalculationWidget(orderedItems: GlobalVariables.cart_items),
              const SizedBox(height: 10),
              PaymentMethodWidget(
                 onTap: () {
                  // Handle the payment action here
                  print("Payment method tapped!");
                  print(GlobalVariables.cart_items.toString());
                  // Assuming grandTotal is defined in your current scope
                  Navigator.pushReplacementNamed(context, '/payments',
                    arguments: {
                      'order_total_amount': grandTotal,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(), // Add your BottomNavBarWidget here
    );
  }
}

class CartItem extends StatelessWidget {
  final int id;
  final String productName;
  final String productPrice;
  final String productImage;
  final String productCartQuantity;
  final VoidCallback onDelete;

  const CartItem({
    Key? key,
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCartQuantity,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Image.asset("assets/images/popular_foods/$productImage.png", width: 120),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName),
                Text(productPrice),
                Text("Quantity: $productCartQuantity"),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset("assets/images/menus/ic_delete.png", width: 25),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  final int counter = 3; // Replace with actual dynamic count if needed

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.business_center, color: Color(0xFF3a3737)),
          onPressed: () {},
        ),
        if (counter != 0)
          Positioned(
            right: 11,
            top: 11,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Text(
                '$counter',
                style: const TextStyle(color: Colors.red, fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class TotalCalculationWidget extends StatelessWidget {
  final List<OrderedItem> orderedItems;

  const TotalCalculationWidget({Key? key, required this.orderedItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = 0.0;
    double totalSGST = 0.0;
    double totalCGST = 0.0;

    // Calculate total, SGST, and CGST
    for (var item in orderedItems) {
      total += item.productPrice * item.quantity; // Base price for total
      totalSGST += item.sgst; // SGST for the item
      totalCGST += item.cgst;// CGST for the item
    }

    grandTotal = total + totalSGST + totalCGST; // Grand total including taxes

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 150, // Increased height for better readability
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Subtotal", style: TextStyle(fontSize: 16)),
                  Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("SGST", style: TextStyle(fontSize: 16)),
                  Text("₹${totalSGST.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("CGST", style: TextStyle(fontSize: 16)),
                  Text("₹${totalCGST.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                ],
              ),
              Divider(), // A divider for separation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Grand Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("₹${grandTotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PaymentMethodWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PaymentMethodWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 60,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.0), // for ripple effect
        child: Card(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Image.asset("assets/images/menus/ic_credit_card.png", width: 50, height: 50),
                const SizedBox(width: 10),
                const Text("Make Payment (Credit/Debit Card/UPI)", style: TextStyle(fontSize: 16, color: Color(0xFF3a3a3b))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*class PaymentMethodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 60,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Image.asset("assets/images/menus/ic_credit_card.png", width: 50, height: 50),
              const SizedBox(width: 10),
              const Text("Make Payment (Credit/Debit Card/UPI)", style: TextStyle(fontSize: 16, color: Color(0xFF3a3a3b))),
            ],
          ),
        ),
      ),
    );
  }
}*/
