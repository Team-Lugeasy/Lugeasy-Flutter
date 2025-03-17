import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'apple_auth_provider.g.dart';

@riverpod
class AppleAuthNotifier extends _$AppleAuthNotifier {
  @override
  AsyncValue<String?> build() => const AsyncValue.data(null);

  Future<void> signInWithApple() async {
    try {
      state = const AsyncValue.loading();

      // Apple 로그인 API
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      state = AsyncValue.data(credential.identityToken);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  void signOut() {
    state = const AsyncValue.data(null);
  }
}
