import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';

// VM для AddSightScreen
class AddSightScreenWidgetModel extends WidgetModel {
  AddSightScreenWidgetModel(WidgetModelDependencies baseDependencies) : super(baseDependencies);
}

WidgetModel buildAddSightScreenWM(BuildContext context) => AddSightScreenWidgetModel(
      const WidgetModelDependencies(),
    );


class AddSightScreenViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();
  final latController = TextEditingController();
  final lotController = TextEditingController();
  final titleFocus = FocusNode();
  final searchFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final latFocus = FocusNode();
  final lotFocus = FocusNode();
  bool isLat = false;

  void tapOnLat() {
    isLat = true;
    notifyListeners();
  }

  void goToLat() {
    isLat = true;
    lotFocus.requestFocus();
    notifyListeners();
  }

  void tapOnLot() {
    isLat = false;
    notifyListeners();
  }

  void goToDescription() {
    isLat = false;
    descriptionFocus.requestFocus();
    notifyListeners();
  }
}
