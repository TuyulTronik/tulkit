import 'package:tulkit/main_lib.dart';
import 'package:tulkit/package_lib.dart';

import '../controller/controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        spacing: 10,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: ProfileHeaderClipper(),
                child: Container(
                  height: 24.hp,
                  width: 100.wp,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.orange],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: -35,
                bottom: 15.wp,
                child: Image.asset(
                  'assets/logo/Tulkit_Text.png',
                  fit: BoxFit.cover,
                  height: 26.wp,
                  width: 90.wp,
                ),
              ),
              Positioned(
                right: -5.wp,
                bottom: -5.wp,
                child: Image.asset(
                  'assets/logo/Tulkit Maskot.png',
                  fit: BoxFit.cover,
                  height: 20.hp,
                ),
              ),
            ],
          ),

          TabBar(
            controller: controller.tabController,
            tabs: controller.tabs,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [xImage(), xQR(), xMap(), xPRINT(), xUTIL()],
            ),
          ),
        ],
      ),
    );
  }

  Widget xImage() {
    return Container(
      color: Colors.grey.shade200,
      child: ResponsiveGrid(
        padding: EdgeInsets.all(10),
        mobileColumns: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(
          controller.gridImage.length,
          (index) => Card(
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      controller.gridImage[index].icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        controller.gridImage[index].title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        controller.gridImage[index].note,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget xQR() {
    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 5,
        children: [
          Container(
            width: 100.wp,
            height: 15.hp,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.lightGreenAccent,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset('assets/icon/qr/qrcode.png', fit: BoxFit.contain),
                Expanded(
                  child: Text(
                    "QR CODE",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ResponsiveGrid(
              mobileColumns: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: List.generate(
                controller.gridQr.length,
                (index) => Card(
                  color: Colors.white,
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            controller.gridQr[index].icon,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              controller.gridQr[index].title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              controller.gridQr[index].note,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget xMap() {
    return Container(
      color: Colors.grey.shade200,
      child: ResponsiveGrid(
        padding: EdgeInsets.all(10),
        mobileColumns: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(
          controller.griMap.length,
          (index) => Card(
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      controller.griMap[index].icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        controller.griMap[index].title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        controller.griMap[index].note,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget xPRINT() {
    return ResponsiveGrid(
      mobileColumns: 4,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(
        controller.print.length,
        (index) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.primaries[index % Colors.primaries.length],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            controller.print[index],
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget xUTIL() {
    return ResponsiveGrid(
      mobileColumns: 4,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(
        controller.utility.length,
        (index) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.primaries[index % Colors.primaries.length],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            controller.utility[index],
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Mulai dari sudut kiri atas
    path.moveTo(0, 0);

    // Garis horizontal atas sampai sebelum sudut kanan atas
    path.lineTo(size.width, 0);

    // turun kanan (tidak full)
    path.lineTo(size.width, size.height * 0.75);

    // Curve pertama (masuk ke dalam)
    path.quadraticBezierTo(
      size.width - 100,
      size.height,
      size.width - 110,
      size.height,
    );

    // Curve kedua (lanjut ke kiri, lebih smooth)
    path.quadraticBezierTo(
      size.width - 115,
      size.height,
      size.width - 115,
      size.height,
    );

    // Garis horizontal bawah
    path.lineTo(0, size.height * 0.75);
    // Tutup path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
