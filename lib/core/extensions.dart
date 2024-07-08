import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:nami_assignment/style/theme.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  CustomColors get customColors => theme.extension<CustomColors>()!;
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // SnackBar
  void showSnackBar(String message, {bool floating = false}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    ));
  }

  // Error SnackBar
  void showErrorSnackBar(String message, {bool floating = false}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: colorScheme.onError)),
      backgroundColor: colorScheme.error,
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    ));
  }
}

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return dateTimeFormat.format(this);
  }
}
