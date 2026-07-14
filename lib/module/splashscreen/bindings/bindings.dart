import 'package:tulkit/package_lib.dart';

import '../controller/controller.dart';

class SplashscreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashscreenController());
  }
}