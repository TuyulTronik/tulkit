import 'package:tulkit/main_lib.dart';
import 'package:tulkit/package_lib.dart';

class OverlayStyleMiddleware extends GetMiddleware {
  final Color statusBarColor;
  final Color systemNavigationBarColor;
  final Color systemNavigationBarDividerColor;
  final Brightness statusBarIconBrightness;
  final Brightness systemNavigationBarIconBrightness;

  OverlayStyleMiddleware({
    this.statusBarColor = Colors.deepOrange,
    this.systemNavigationBarColor = Colors.blue,
    this.systemNavigationBarDividerColor = Colors.blue,
    this.statusBarIconBrightness = Brightness.light,
    this.systemNavigationBarIconBrightness = Brightness.light,
  });

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page?.copy(
      page:
          () => OverlayWrapper(
            statusBarColor: statusBarColor,
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
            statusBarIconBrightness: statusBarIconBrightness,
            systemNavigationBarIconBrightness:
                systemNavigationBarIconBrightness,
            child: page.page(),
          ),
    );
  }
}
