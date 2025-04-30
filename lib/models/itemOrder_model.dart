// /lib/models/itemOrder_model.dart

import 'itemOrder_model.dart'; // Import your OrderedItem class



class FoodOrder {
  final int orderId;
  final int userId;
  final DateTime orderDateTime;
  final double grandTotal;
  final int numberOfItems;
  final DateTime deliveryTime;
  final List<OrderedItem> items;

  FoodOrder({
    required this.orderId,
    required this.userId,
    required this.orderDateTime,
    required this.grandTotal,
    required this.numberOfItems,
    required this.deliveryTime,
    required this.items,
  });
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'order_date_time': orderDateTime.toIso8601String(),
      'grand_total': grandTotal,
      'number_of_items': numberOfItems,
      'delivery_time' : deliveryTime.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      orderId: json['order_id'] ?? 0,
      userId: json['user_id'] ?? 0, // Default value if null
      orderDateTime: DateTime.parse(json['order_date_time']),
      grandTotal: json['grand_total']?.toDouble() ?? 0.0, // Default to 0.0
      numberOfItems: json['number_of_items'] ?? 0, // Default value if null
      deliveryTime: DateTime.parse(json['delivery_time']),
      items: (json['items'] as List)
          .map((item) => OrderedItem.fromJson(item))
          .toList(),
    );
  }
}



class OrderedItem {
  final int id;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  final double sgst; // State Goods and Services Tax
  final double cgst; // Central Goods and Services Tax

  OrderedItem({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.sgst,
    required this.cgst,
  });

  factory OrderedItem.fromJson(Map<String, dynamic> json) {
    return OrderedItem(
      id: json['id'] ?? 0, // Default value if null
      productName: json['productName'] ?? '', // Default to empty string
      productImage: json['productImage'] ?? '', // Default to empty string
      productPrice: json['productPrice']?.toDouble() ?? 0.0, // Default to 0.0
      quantity: json['quantity'] ?? 1, // Default to 1
      sgst: json['sgst']?.toDouble() ?? 0.0, // Default to 0.0
      cgst: json['cgst']?.toDouble() ?? 0.0, // Default to 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'quantity': quantity,
      'sgst': sgst,
      'cgst': cgst,
    };
  }
}


class FoodOrderResponse {
  final bool success;
  final FoodOrder data;

  FoodOrderResponse({
    required this.success,
    required this.data,
  });

  factory FoodOrderResponse.fromJson(Map<String, dynamic> json) {
    return FoodOrderResponse(
      success: json['success'],
      data: FoodOrder.fromJson(json['data']),
    );
  }
}
