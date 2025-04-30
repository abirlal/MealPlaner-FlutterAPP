// loginRegistration_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealPlanner/config/app_config.dart';
import 'package:mealPlanner/config/global_variables.dart';
import 'package:mealPlanner/models/loginRegistration_model.dart'; // Import the model with the correct relative path



class LoginRegistrationService {
  final String _baseUrl = AppConfig.baseUrl;

  Future<LoginResponse> login(String username, String password) async {
    final String apiUrl = '$_baseUrl/login';
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        
        // Store the bearer token globally
        GlobalVariables.bearerToken = loginResponse.accessToken;
        final fullName = loginResponse.userData.userFullname;
        GlobalVariables.profileId = loginResponse.userData.userId;
        GlobalVariables.profileName = fullName;
        GlobalVariables.profileFirstName = fullName.split(' ').first;
        GlobalVariables.profileEmail=loginResponse.userData.userEmail;
        GlobalVariables.profileMob=loginResponse.userData.userMob;

        return loginResponse;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['error']?.toString() ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<bool> registerUser(UserData user) async {
    final String apiUrl = '$_baseUrl/users';
    try {
      String jsonPayload = jsonEncode(user.toJson());
      print("Payload to send: $jsonPayload"); 
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonPayload,
      );
      if (response.statusCode == 201){
        final responseData = jsonDecode(response.body);
        print("Response: $responseData \n");
        return responseData['success']; // Return true if successful
      } else {
          throw Exception('Failed to load food item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
    
  }
}

