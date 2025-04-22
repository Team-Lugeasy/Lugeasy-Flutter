import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/view/main/main_container.dart';

import '../../provider/apple_auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                  onPressed: appleLoginState is AsyncLoading
                      ? null
                      : () => _appleLogin(context, ref),
                  child: appleLoginState is AsyncLoading
                      ? CircularProgressIndicator()
                      : Text("Apple Login"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _googleLogin(context, ref),
                  child: Text("Google Login"),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainContainer(),
                      ),
                    );
                  },
                  child: Text("Guest Login"),
                ),
              ] else if (Platform.isAndroid) ...[
                // Android
                ElevatedButton(
                  onPressed: () => _googleLogin(context, ref),
                  child: Text("Google Login"),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainContainer(),
                      ),
                    );
                  },
                  child: Text("Guest Login"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _appleLogin(BuildContext context, WidgetRef ref) async {
    try {
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
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
  }

  Future<void> _googleLogin(BuildContext context, WidgetRef ref) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
        // 이 옵션이 serverAuthCode를 활성화함
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID']!,
      ).signIn();

      print("server auth code");
      print(googleUser?.serverAuthCode);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );
      print("idToken");
      print(googleAuth?.idToken);
      print(googleAuth?.accessToken);
      // final token = await FirebaseAuth.instance.signInWithCredential(
      //   credential,
      // );
      // debugPrint(token.toString());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainContainer()),
      );
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
  }
}
