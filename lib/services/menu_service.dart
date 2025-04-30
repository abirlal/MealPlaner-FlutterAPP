// lib/services/menu_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealPlanner/models/menu_model.dart';
import 'package:mealPlanner/config/app_config.dart';
import 'package:mealPlanner/config/global_variables.dart';

class MenuService {
 
  MenuService();
  final String _baseUrl = '${AppConfig.baseUrl}/menus';

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer ${GlobalVariables.bearerToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['data'];
      return jsonData.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  
}
