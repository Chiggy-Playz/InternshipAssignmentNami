import 'package:flutter/material.dart';
import 'package:nami_assignment/style/icons.dart';

class ChipMenuEntry {
  final Widget child;
  final Widget? leading;

  ChipMenuEntry({
    required this.child,
    this.leading,
  });
}

class ChipMenu extends StatefulWidget {
  const ChipMenu({
    super.key,
    required this.menuEntries,
    this.onSelected,
    this.initialSelectionIndex = 0,
  });

  final int initialSelectionIndex;
  final List<ChipMenuEntry> menuEntries;
  final Function(ChipMenuEntry)? onSelected;

  @override
  State<ChipMenu> createState() => _ChipMenuState();
}

class _ChipMenuState extends State<ChipMenu> {
  late ChipMenuEntry _selectedEntry;

  @override
  void initState() {
    super.initState();
    _selectedEntry = widget.menuEntries[widget.initialSelectionIndex];
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return FilterChip(
          label: Row(
            children: [
              _selectedEntry.child,
              const SizedBox(width: 8),
              const Icon(
                SmartAttendIcons.arrowDown,
                size: 12,
              ),
            ],
          ),
          selected: false,
          onSelected: (_) {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          showCheckmark: false,
        );
      },
      menuChildren: [
        for (final entry in widget.menuEntries)
          MenuItemButton(
            leadingIcon: entry.leading,
            child: entry.child,
            onPressed: () {
              setState(() {
                _selectedEntry = entry;
              });
              widget.onSelected?.call(entry);
            },
          ),
      ],
    );
  }
}
