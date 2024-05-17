import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ItemController extends GetxController {
  List<String> selectedItems = [];

  void toggleSelected(String itemId) {
    if (selectedItems.contains(itemId)) {
      selectedItems.remove(itemId);
    } else {
      selectedItems.add(itemId);
    }
    update();
  }
}

