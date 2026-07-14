import 'package:tulkit/main_lib.dart';
import 'package:tulkit/package_lib.dart';

import '../controller/controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange.shade500,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90.wp,
                height: 40.hp,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo/Tulkit Maskot.png"),
                  ),
                ),
              ),
              SizedBox(
                width: 90.wp,
                child: Column(
                  spacing: 5,
                  children: [
                    Obx(() {
                      return LinearProgressIndicator(
                        value: controller.progress.value,
                        color: Colors.indigo,
                      );
                    }),
                    Obx(
                      () => Text(
                        controller.statusText.value,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
