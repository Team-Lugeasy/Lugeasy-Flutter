import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/core/util/color_style.dart';
import 'package:lugeasy/core/util/text_style.dart';
import 'package:lugeasy/providers/auth/locale_provider.dart';
import 'package:lugeasy/view/login/login_view_model.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:lugeasy/view/popup/custom_toast.dart';
import 'package:lugeasy/widgets/button.dart';
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
        CustomToast.showError(context, next.message.toString());
      }

      if (next is LoginSuccess) {
        CustomToast.showSuccess(context, next.message.toString());
      }
    });

    final locale = ref.watch(localeNotifierProvider);

    return Scaffold(
        backgroundColor: LugeasyColorStyles.blue500,
        body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 60.h,
            ),
            Button(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(right: 20.w),
              child: Icon(Icons.language),
              onTap: () {
                // 현재 로케일이 한국어면 영어로, 영어면 한국어로 변경
                final newLocale = locale.value?.languageCode == 'ko'
                    ? const Locale('en')
                    : const Locale('ko');
                ref
                    .read(localeNotifierProvider.notifier)
                    .updateLocale(newLocale);
              },
            ),
            SizedBox(
              height: 240.h,
            ),
            Image.asset(
              'assets/icon/icon_marker.png',
              width: 118.w,
              height: 118.h,
            ),
            SizedBox(height: 178.h),
            if (Platform.isIOS) ...[
              // iOS
              Button(
                  child: Image.asset(
                    "assets/image/image_google_login.png",
                    width: 372.w,
                    height: 60.h,
                    fit: BoxFit.contain,
                  ),
                  onTap: () => viewModel.googleLogin()),
              SizedBox(height: 20.h),
              Button(
                child: Image.asset(
                  "assets/image/image_apple_login.png",
                  width: 372.w,
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
                onTap: () => _appleLogin(context, ref),
              ),
              SizedBox(height: 60.h),
              Button(
                onTap: () {
                  navigateToMainContainer();
                },
                child: Text(
                  context.l10n.guest_login,
                  style: LugeasyTextStyles.body5.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
              ),
            ] else if (Platform.isAndroid) ...[
              // Android
              Button(
                  child: Image.asset(
                    "assets/image/image_google_login.png",
                    width: 372.w,
                    height: 60.h,
                    fit: BoxFit.contain,
                  ),
                  onTap: () => viewModel.googleLogin()),
              SizedBox(height: 60.h),
              Button(
                onTap: () {
                  navigateToMainContainer();
                },
                child: Text(
                  context.l10n.guest_login,
                  style: LugeasyTextStyles.body5.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
              ),
            ]
          ]),
        ));
  }

  // 지수야 해줘
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
