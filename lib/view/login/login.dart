import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/view/main/main_container.dart';

import '../../services/intro_services.dart';
import '../../provider/apple_auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appleLoginState = ref.watch(appleAuthNotifierProvider);

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
                  onPressed:
                      appleLoginState is AsyncLoading
                          ? null
                          : () => _handleLogin(context, ref, "Apple Login"),
                  child:
                      appleLoginState is AsyncLoading
                          ? CircularProgressIndicator()
                          : Text("Apple Login"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _handleLogin(context, ref, "Google Login"),
                  child: Text("Google Login"),
                ),
              ] else if (Platform.isAndroid) ...[
                // Android
                ElevatedButton(
                  onPressed: () => _handleLogin(context, ref, "Google Login"),
                  child: Text("Google Login"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    WidgetRef ref,
    String loginType,
  ) async {
    try {
      final introServices = IntroServices();

      if (loginType == "Apple Login") {
        // Apple 로그인 처리
        final appleNotifier = ref.read(appleAuthNotifierProvider.notifier);
        await appleNotifier.signInWithApple();

        final appleLoginState = ref.read(appleAuthNotifierProvider);
        appleLoginState.when(
          data: (token) {
            if (token != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainContainer()),
              );
            }
          },
          error: (error, _) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Apple 로그인 실패: $error")));
          },
          loading: () {}, // 로딩 중 UI 처리는 UI에서 진행
        );
      } else if (loginType == "Google Login") {
        // Google 로그인 처리
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
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
  }
}
