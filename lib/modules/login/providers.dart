import 'package:nami_assignment/modules/login/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class AuthHandler extends _$AuthHandler {
  @override
  Future<UserModel?> build() async {
    // Look for a token in the local storage and return it
    // But thats out of the scope for this assignment
    // So we will just return null in beginning

    return null;
  }

  Future<void> login(String email, String password) async {
    // This is where you would call the API to login
    // But thats out of the scope for this assignment
    // So we'll create a dummy user

    await Future.delayed(const Duration(milliseconds: 500));
    state = AsyncData(
      UserModel(
          id: 1,
          email: email,
          name: 'Chiggy',
          imageUrl:
              'https://en.gravatar.com/avatar/ea8be10248440badd05ded1b216a7492?s=1024' // Me =D
          ),
    );
  }

  Future<void> signOut() async {
    // This is where you would call the API to logout
    // But thats out of the scope for this assignment
    // So we'll just set the user to null

    await Future.delayed(const Duration(milliseconds: 500));
    state = const AsyncData(null);
  }
}
