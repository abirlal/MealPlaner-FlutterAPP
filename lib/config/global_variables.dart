// /lib/config/global_variables.dart


import 'package:mealPlanner/models/itemOrder_model.dart';


class GlobalVariables {
  static String bearerToken = "";
  static int profileId = 0;
  static String profileName = "";
  static String profileFirstName = "";
  static String profileEmail = "";
  static String profileMob = "";

  static double sgst = 0.0;
  static double cgst = 0.0;

  // ignore: non_constant_identifier_names
  static List<OrderedItem> cart_items = [];



  // Add other global variables if needed
  // static String? anotherGlobalVariable;
  // Initialize SGST and CGST with default values (e.g., 9%)
  static void initialize() {
    sgst = 0.0225;
    cgst = 0.0225;
  }
}
