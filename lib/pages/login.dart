import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/modules/login/providers.dart';
import 'package:nami_assignment/pages/courses.dart';
import 'package:nami_assignment/widgets/smart_attend_logo.dart';
import 'package:nami_assignment/widgets/buttons.dart' as buttons;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const String routePath = '/login';
  static const String routeName = 'Login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 64,
            ),
            const Center(
              child: SmartAttendLogo(),
            ),
            const SizedBox(height: 24),
            Text(
              "SmartAttend",
              style: context.textTheme.headlineLarge!.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(child: SizedBox()),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Your ID",
                hintText: "Your ID",
                prefixIcon: SizedBox(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Password",
                prefixIcon: SizedBox(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            const SizedBox(height: 32),
            buttons.FilledButton(
              child: Text(
                "Log in",
                style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                final authHandler = ref.read(authHandlerProvider.notifier);

                // Replace the empty strings with the actual ID and password
                // After validating above form fields
                await authHandler.login("", "");
                if (!context.mounted) return;
                context.go(CoursesPage.routePath);
              },
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {},
              child: Text(
                "Forgot Password",
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 32),
            buttons.OutlinedButton(
              child: Text(
                "Create new account",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {},
            ),
            const Expanded(child: SizedBox()),
            Text(
              "Powered by Lucify",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
