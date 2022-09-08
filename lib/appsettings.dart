import 'package:flutter/material.dart';

typedef OnSubmitted = void Function(String)?;

class AppSettings extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final latController = TextEditingController();
  final lotController = TextEditingController();
  final titleFocus = FocusNode();
  final latFocus = FocusNode();
  final lotFocus = FocusNode();
  final descriptionFocus = FocusNode();

  bool isDarkMode = false;

  bool switchTheme({required bool value}) {
    notifyListeners();

    return isDarkMode = value;
  }
}
