import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/core/router.dart';
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

    return state.value;
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

    // Should cause a rebuild of the router
    ref.invalidate(routerProvider);
  }
}
