// splashscreen_view.dart

import 'package:tulkit/main_lib.dart';
import 'package:tulkit/package_lib.dart';

import '../controller/splashscreen_controller.dart';

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
              // Logo
              Container(
                width: 90.wp,
                height: 40.hp,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo/Tulkit Maskot.png'),
                  ),
                ),
              ),
              
              SizedBox(
                width: 90.wp,
                child: Column(
                  spacing: 5,
                  children: [
                    // Progress Bar
                    Obx(() {
                      return LinearProgressIndicator(
                        value: controller.progress.value,
                        color: Colors.indigo,
                        backgroundColor: Colors.indigo.shade100,
                      );
                    }),
                    
                    // Status Text
                    Obx(
                      () => Text(
                        controller.statusText.value,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    // ✅ Tambahkan tombol retry jika error
                    Obx(() {
                      final isError = controller.statusText.value.contains('gagal') ||
                                      controller.statusText.value.contains('Error');
                      
                      if (isError) {
                        return Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: ElevatedButton(
                            onPressed: controller.retryCheck,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Coba Lagi'),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
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