

import 'package:tulkit/main_lib.dart';

class OverlayWrapper extends StatelessWidget {
  final Widget child;
  final SystemUiOverlayStyle? overlayStyle;
  final Color? statusBarColor;
  final Color? systemNavigationBarColor;
  final Color? systemNavigationBarDividerColor;
  final Brightness? statusBarIconBrightness;
  final Brightness? systemNavigationBarIconBrightness;

  const OverlayWrapper({
    super.key,
    required this.child,
    this.overlayStyle,
    this.statusBarColor,
    this.systemNavigationBarColor,
    this.systemNavigationBarDividerColor,
    this.statusBarIconBrightness,
    this.systemNavigationBarIconBrightness,
  });

  @override
  Widget build(BuildContext context) {
    // Jika overlayStyle disediakan, gunakan itu
    if (overlayStyle != null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle!,
        child: child,
      );
    }

    // Otherwise, build from individual parameters
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        statusBarBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarColor: systemNavigationBarColor ?? Colors.transparent,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? Brightness.dark,
        systemNavigationBarDividerColor: systemNavigationBarDividerColor ?? Colors.transparent,
      ),
      child: child,
    );
  }
}