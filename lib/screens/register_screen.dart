import 'package:flutter/material.dart';
import 'package:mealPlanner/models/loginRegistration_model.dart';
import 'package:mealPlanner/services/alert_service.dart';
import 'package:mealPlanner/services/loginRegistration_service.dart';

class RegistrationScreenPage extends StatefulWidget {
  @override
  _RegistrationScreenPageState createState() => _RegistrationScreenPageState();
}

class _RegistrationScreenPageState extends State<RegistrationScreenPage> {
  String? selectedLocation;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final LoginRegistrationService _loginRegistrationService = LoginRegistrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( 
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(nameController, 'Full Name', TextInputType.name, 'Please enter your full name', customValidator: validateName),
                _buildTextField(mobileController, 'Mobile No (+91)', TextInputType.phone, 'Please enter your mobile number',customValidator: validateMobile),
                _buildTextField(emailController, 'Email', TextInputType.emailAddress, 'Please enter your email', customValidator: validateEmail),
                _buildTextField(passwordController, 'Password', TextInputType.visiblePassword, 'Please enter your password', obscureText: true, customValidator: validatePassword),
                _buildTextField(confirmPasswordController, 'Confirm Password', TextInputType.visiblePassword, 'Passwords do not match', obscureText: true, confirmPassword: true),
                //SizedBox(height: 20),
                _buildLocationDropdown(),
                SizedBox(height: 20),
                _buildRegisterButton(),
                _buildLoginRedirectButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, TextInputType keyboardType, String errorMessage, {bool obscureText = false, bool confirmPassword = false, String? Function(String?)? customValidator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: customValidator ?? (value)  {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        if (confirmPassword && value != passwordController.text) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Select Location'),
      value: selectedLocation,
      onChanged: (String? newValue) {
        setState(() {
          selectedLocation = newValue;
        });
      },
      items: <String>[
        'Kolkata, India',
        'Noida, India',
        'Bangalore, India',
        'Gurugram, India',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  ElevatedButton _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _registerUser, // Call the async function
      child: Text('Register'),
    );
  }

  TextButton _buildLoginRedirectButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Text('Already have an account? Login'),
    );
  }

  Future<void> _registerUser() async {
  if (_formKey.currentState?.validate() ?? false) {
    UserData user = UserData(
      userId: 0,
      userName: mobileController.text,
      userFullname: nameController.text,
      userEmail: emailController.text,
      userMob: mobileController.text,
      userPass: passwordController.text,
      userLocation: selectedLocation ?? '',
    );

    try {
      // Await the registration service call
      bool isSuccess = await _loginRegistrationService.registerUser(user);
      _showSuccessFailureAlert(isSuccess);
    } catch (e) {
      // Handle any exceptions
      print("Registration error: $e");
      _showSuccessFailureAlert(false);
    }
  }
}


  void _showSuccessFailureAlert(bool isSuccess) {
    String title;
    String message;

    if (isSuccess) {
      title = 'Success';
      message = 'Registration Done. Please use phone no as Username.';
    } else {
      title = 'Error';
      message = 'Registration Failed. Please contact Facility Center.';
    }
    AlertService.showAlert(
      context: context,
      title: title,
      message: message,
      buttonText: 'OK',
      onButtonPressed: () {
        // Handle the button press (e.g., log an event or dismiss the alert)
      },
    );
    if(isSuccess) {Navigator.pushNamed(context, '/login');}
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!regex.hasMatch(value)) {
      return 'Email must be a valid Gmail address';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    final regex = RegExp(r'^\d{10}$');
    if (!regex.hasMatch(value)) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    final regex = RegExp(r'^\S+ \S+$'); // Two words
    if (!regex.hasMatch(value)) {
      return 'Name must contain at least two words';
    }
    return null;
  }

}
