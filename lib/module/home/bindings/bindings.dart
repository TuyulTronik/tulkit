import 'package:tulkit/package_lib.dart';

import '../controller/controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}