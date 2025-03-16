import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lugeasy/view/main/main_container.dart';
import '../../services/intro_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              if (Platform.isIOS) ...[
                // iOS
                ElevatedButton(
                  onPressed: () => _handleLogin(context, "Apple Login"),
                  child: Text("apple login"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _handleLogin(context, "Google Login"),
                  child: Text("google login"),
                ),
              ] else if (Platform.isAndroid) ...[
                // Android
                ElevatedButton(
                  onPressed: () => _handleLogin(context, "Google Login"),
                  child: Text("google login"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, String loginType) async {
    try {
      final introServices = IntroServices();
      final response = await introServices.mockLoginApi(loginType);
      if (response == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainContainer()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login Failed: $response")));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
  }
}
