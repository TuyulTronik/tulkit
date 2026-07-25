import 'package:tulkit/package_lib.dart';

import '../controller/splashscreen_controller.dart';

class SplashscreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashscreenController());
  }
}