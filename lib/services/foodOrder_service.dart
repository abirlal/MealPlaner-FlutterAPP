// /lib/services/order_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealPlanner/config/app_config.dart';
import 'package:mealPlanner/config/global_variables.dart';
import 'package:mealPlanner/models/itemOrder_model.dart';

class OrderService {
  final String _baseUrl = AppConfig.baseUrl; 
  late final String apiUrl;

  Future<FoodOrder> createOrder(FoodOrder order) async {
    apiUrl = '$_baseUrl/orders';
    try {
      String jsonPayload = jsonEncode(order.toJson());
      print("Payload to send: $jsonPayload"); 
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${GlobalVariables.bearerToken}',
          'Content-Type': 'application/json',
        },
        body: jsonPayload, // Convert FoodOrder to JSON
      );
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Response: $responseData \n");
        final foodOrderResponse = FoodOrderResponse.fromJson(responseData);
        return foodOrderResponse.data;
      } else {
        throw Exception('Failed to load food item. Status code: ${response.statusCode} and Response body: ${response.body}');
      }
    } catch (error) {
      //print('Error creating order: $error');
      throw Exception('Error creating order: $error');
    }
  }

  Future<List<FoodOrder>> fetchOrders() async {
    apiUrl = '$_baseUrl/orders/active_orders';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${GlobalVariables.bearerToken}',
        'Content-Type': 'application/json',
      });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Response: $jsonData \n");
      return (jsonData['data'] as List)
          .map((order) => FoodOrder.fromJson(order))
          .toList();
    } else {
      throw Exception('Failed to load orders: ${response.reasonPhrase}');
    }
  }
}
