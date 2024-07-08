import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/modules/login/providers.dart';
import 'package:nami_assignment/style/icons.dart';

class AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
  });

  final Widget? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    // The double AppBar is intentional
    // The first one acts as a padding which pushes the second one down
    // The second one is the actual AppBar
    return material.AppBar(
      automaticallyImplyLeading: false,
      bottom: material.AppBar(
        automaticallyImplyLeading: false,
        leading: parentRoute?.impliesAppBarDismissal ?? false
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: context.colorScheme.tertiary,
                    ),
                    child: Icon(
                      SmartAttendIcons.arrowLeft,
                      color: context.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ),
                ),
              )
            : null,
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
