// /lib/models/login_model.dart

class LoginResponse {
  final bool success;
  final String accessToken;
  final String tokenType;
  final UserData userData;
  final Map<String, dynamic> error;

  LoginResponse({
    required this.success,
    required this.accessToken,
    required this.tokenType,
    required this.userData,
    required this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      userData: UserData.fromJson(json['user_data']),
      error: json['error'] ?? {},
    );
  }
}

class UserData {
  final int userId;
  final String userName;
  final String userPass;
  //final String userType;
  final String userFullname;
  final String userEmail;
  final String userMob;
  final String userLocation;
  
  UserData({
    required this.userId,
    required this.userName,
    required this.userPass,
    //required this.userType,
    required this.userFullname,
    required this.userEmail,
    required this.userMob,
    required this.userLocation,

  });

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'password': userPass,
      'fullname': userFullname,
      'email': userEmail,
      'mob': userMob,
      'location': userLocation,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'],
      userName: json['user_name'],
      userPass: json['user_pass'],
      //userType: json['user_type'],
      userFullname: json['user_fullname'],
      userEmail:json['user_email'],
      userMob: json['user_mob'],
      userLocation: json['user_location']
    );
  }
}
