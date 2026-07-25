import 'package:tulkit/main_lib.dart';
import 'package:tulkit/package_lib.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = const [
    Tab(text: "IMAGE"),
    Tab(text: "QR CODE"),
    Tab(text: "MAP"),
    Tab(text: "PRINT"),
    Tab(text: "UTILITY"),
  ];
  List<MenuItem> gridImage = [
    MenuItem(
      "Add Watermark",
      "assets/icon/image/im_watermark.png",
      "Protect your image with custom text or logos.",
    ),
    MenuItem(
      "Format Converter",
      "assets/icon/image/im_converter.png",
      "Easy convert between JPG, PNG and More.",
    ),
    MenuItem(
      "Combiner",
      "assets/icon/image/im_combine.png",
      "Merger multiple image into one seemless photo.",
    ),
    MenuItem(
      "Compressor",
      "assets/icon/image/im_compress.png",
      "Reduce image size without loosing quality.",
    ),
  ];
  List<MenuItem> gridQr = [
    MenuItem(
      "Text",
      "assets/icon/qr/qr_text.png",
      "Generate QR codes from plain text or custom messages.",
    ),
    MenuItem(
      "Url",
      "assets/icon/qr/qr_url.png",
      "Create QR codes that instantly open websites or links.",
    ),
    MenuItem(
      "Wifi",
      "assets/icon/qr/qr_wifi.png",
      "Share Wi-Fi access quickly without typing passwords.",
    ),
    MenuItem(
      "vCard",
      "assets/icon/qr/qr_vcard.png",
      "Generate contact QR codes for fast saving and sharing.",
    ),
  ];
  List<MenuItem> griMap = [
    MenuItem(
      "Live Tracking",
      "assets/icon/qr/qr_text.png",
      "Monitor real-time location data.",
    ),
    MenuItem(
      "Location History",
      "assets/icon/qr/qr_url.png",
      "Review past movements and routes.",
    ),
    MenuItem(
      "Geo Tag Photo",
      "assets/icon/qr/qr_wifi.png",
      "Add Location to your photo.",
    ),
    MenuItem(
      "Route Finder",
      "assets/icon/qr/qr_vcard.png",
      "Plan optimal paths and Navigation.",
    ),
    MenuItem(
      "Area Calculator",
      "assets/icon/qr/qr_vcard.png",
      "Measure land area precisely.",
    ),
  ];
 
  // final print = ["POM", "PDF PRINT", "THERMAL"];
  // final utility = ["READER"];
  final print = ["POM", "POS", "PDF PRINT"];
  final utility = ["READER", "AUDIO", "VIDEO", "AI"];
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class MenuItem {
  final String title;
  final String icon;
  final String note;

  const MenuItem(this.title, this.icon, this.note);
}
