import 'package:get/get.dart';

class HomeController extends GetxController {
  var totalRecords = 12.obs;
  var lastUpdate = "2h".obs;

  // Navigation Callbacks
  void onCreateRecord() {
    // Example navigation: Get.toNamed("/create");
    print("Navigate to Create Record");
  }

  void onNavigateToRecords() {
    // Example navigation: Get.toNamed("/records");
    print("Navigate to Records");
  }
}
 