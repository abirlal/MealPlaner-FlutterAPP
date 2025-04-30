
// /lib/services/foodItem_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealPlanner/config/app_config.dart';
import 'package:mealPlanner/config/global_variables.dart';
import 'package:mealPlanner/models/foodItem_model.dart';

class FoodItemService {

  final String _baseUrl = AppConfig.baseUrl; 

  Future<List<FoodItem>> fetchFoodItems(String menuId) async {
    try {
      final String apiUrl;
      if (menuId == '0') {
        apiUrl = '$_baseUrl/items'; // Base endpoint
      } else if (menuId == '1') {
        apiUrl = '$_baseUrl/items'; // Base endpoint
      } else {
        apiUrl = '$_baseUrl/items_by_menu_id/$menuId'; // Include menuId as a query parameter
      }
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${GlobalVariables.bearerToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        return data.map((item) => FoodItem.fromJson(item)).toList();
      } else {
        // Handle different HTTP status codes
        throw Exception('Failed to load food items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and handle exceptions
      throw Exception('Failed to load food items. Error: $e');
    }
  }

  
  // Fetch food item by ID
  Future<FoodItem> fetchFoodItem(int itemId) async {
    try {
      final String apiUrl = '$_baseUrl/items/$itemId';
      
      final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer ${GlobalVariables.bearerToken}',
          },
        );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          final jsonData = jsonResponse['data'];
          return FoodItem.fromJson(jsonData);
        } else {
          throw Exception('Failed to load food item. ${jsonResponse['error']}');
        }
      } else {
        throw Exception('Failed to load food item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load food items. Error: $e');
    }
  }
}
