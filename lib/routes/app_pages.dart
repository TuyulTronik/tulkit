import 'package:tulkit/main_lib.dart';
import 'package:tulkit/module/home/view/views.dart';
import 'package:tulkit/module/splashscreen/view/view.dart';
import 'package:tulkit/package_lib.dart';

import '../module/home/bindings/bindings.dart';
import '../module/splashscreen/bindings/bindings.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const xINITIAL = Routes.aSplashcreen;

  static final routes = [
    ///---------------------------------------------------------[MAIN MENU]---------------------------------------------------------///
    GetPage(
      name: _Paths.bSplashcreen,
      page: () => const SplashscreenView(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 700),
      binding: SplashscreenBindings(),
      middlewares: [
        OverlayStyleMiddleware(
          statusBarColor: Colors.blue,
          statusBarIconBrightness: Brightness.light,
        ),
      ],
    ),
    GetPage(
      name: _Paths.bHome,
      page: () => const HomeView(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 700),
      binding: HomeBindings(),
      middlewares: [
        OverlayStyleMiddleware(
          statusBarColor: Colors.red,
          statusBarIconBrightness: Brightness.light,
        ),
      ],
    ),
  ];
}
