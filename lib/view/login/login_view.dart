import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/providers/auth/locale_provider.dart';
import 'package:lugeasy/data/models/root_response.dart';
import 'package:lugeasy/data/datasources/remote/intro_services.dart';
import 'package:lugeasy/data/models/login_response.dart';
import 'package:lugeasy/core/util/log_util.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lugeasy/core/extensions/context_extension.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  void navigateToMainContainer() {
    NavigationService().navigateClear(NavigationRoute.mainContainer);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.login), // 예: 다국어 "로그인"
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // 현재 로케일이 한국어면 영어로, 영어면 한국어로 변경
              final newLocale = locale.value?.languageCode == 'ko'
                  ? const Locale('en')
                  : const Locale('ko');
              ref.read(localeNotifierProvider.notifier).updateLocale(newLocale);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.welcome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              if (Platform.isIOS) ...[
                // iOS
                ElevatedButton(
                  onPressed: () => _appleLogin(context, ref),
                  child: Text(context.l10n.apple_login),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _googleLogin(context, ref),
                  child: Text(context.l10n.google_login),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    navigateToMainContainer();
                  },
                  child: Text(context.l10n.guest_login),
                ),
              ] else if (Platform.isAndroid) ...[
                // Android
                ElevatedButton(
                  onPressed: () => _googleLogin(context, ref),
                  child: Text(context.l10n.google_login),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    navigateToMainContainer();
                  },
                  child: Text(context.l10n.guest_login),
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
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final authorizationCode = credential.authorizationCode;

      // 서버 API 연동 전 authorizationCode 확인용 팝업
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Apple Auth Code"),
          content: SingleChildScrollView(
            child: SelectableText(authorizationCode),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      );

      // TODO: 이후 실제 서버 요청
      // await ref.read(authProvider.notifier).loginWithApple(authorizationCode);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Apple 로그인 실패: ${error.toString()}")),
      );
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

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final token = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final idToken = googleAuth?.idToken;
      if (idToken == null) {
        logger.d("ID 토큰이 null입니다.");
        return;
      }
      final result = await IntroServices().login(idToken, 'GOOGLE');

      if (result is Success<LoginResponse>) {
        // 로그인 성공 시, 메인 화면으로 이동
        navigateToMainContainer();
      } else if (result is Error<LoginResponse>) {
        // 로그인 실패 시 메시지 출력
        logger.d("로그인 실패: ${result.message}");
      }
    } catch (error) {
      logger.d(error.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
  }
}
