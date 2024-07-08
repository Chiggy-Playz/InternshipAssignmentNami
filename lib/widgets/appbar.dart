import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/modules/login/providers.dart';

class AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
  });

  final Widget? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The double AppBar is intentional
    // The first one acts as a padding which pushes the second one down
    // The second one is the actual AppBar
    return material.AppBar(
      bottom: material.AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: title,
        ),
        actions: ref.watch(authHandlerProvider).whenOrNull(
          data: (user) {
            if (user == null) {
              return [];
            }
            return [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundImage: user.imageUrl != null
                      ? NetworkImage(user.imageUrl!)
                      : null,
                ),
              ),
            ];
          },
        ),
      ),
    );
  }

  // This is required for the AppBar to work
  // The toolbar height is doubled to make space for the second AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.5);
}
