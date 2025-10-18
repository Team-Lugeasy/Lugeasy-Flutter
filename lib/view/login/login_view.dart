import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/providers/auth/locale_provider.dart';
import 'package:lugeasy/view/login/login_view_model.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:lugeasy/core/extensions/context_extension.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  void navigateToMainContainer() {
    NavigationService().navigateClear(NavigationRoute.mainContainer);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Fail : ${next.message.toString()}")),
        );
      }

      if (next is LoginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${next.message.toString()}")),
        );
      }
    });
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
                  onPressed: () => viewModel.googleLogin(),
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
                  onPressed: () => viewModel.googleLogin(),
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
    } catch (error) {}
  }
}
