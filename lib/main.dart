import 'package:flutter/foundation.dart';
import 'package:tulkit/main_lib.dart';
import 'package:tulkit/package_lib.dart';
import 'package:tulkit/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Untuk Android API 29+
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Wajib transparan
        systemNavigationBarColor: Colors.transparent, // Wajib transparan
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "TULKIT",
      initialRoute: AppPages.xINITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) {
          return SizedBox.shrink();
        }
        return ResponsiveInitializerSafe(
          config: const ResponsiveConfig(
            designWidth: 375,
            designHeight: 812,
            enableLogging: kDebugMode,
          ),
          child: child,
        );
      },
    );
  }
}
