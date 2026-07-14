import 'dart:async';

import 'package:flutter_apk_updater/flutter_apk_updater.dart';
import 'package:tulkit/package_lib.dart';
import 'package:tulkit/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  final progress = 0.0.obs;
  final statusText = 'Initializing...'.obs;

  late final ApkUpdater _updater;

  @override
  void onInit() async {
    _updater = ApkUpdater(
      config: const ApkUpdaterConfig(
        owner: 'username',
        repository: 'repository',
        apkPattern: 'release',
      ),
    );
    await _initialize();
    super.onInit();
  }

  Future<void> _initialize() async {
    try {
      _updateProgress(value: 0.10, message: 'Checking for updates...');

      final result = await _updater.check();

      if (result is Error<UpdateInfo>) {
        _goHome();
        return;
      }

      final update = (result as Success<UpdateInfo>).data;

      if (!update.hasUpdate) {
        _updateProgress(value: 1, message: 'Application is up to date.');

        await Future.delayed(const Duration(milliseconds: 600));

        _goHome();

        return;
      }

      _updateProgress(value: 0.20, message: 'Downloading update...');

      final download = await _updater.download(
        updateInfo: update,
        onProgress: (downloadInfo) {
          progress.value = 0.2 + (downloadInfo.progress * 0.7);

          statusText.value =
              'Downloading ${(downloadInfo.progress * 100).toStringAsFixed(0)} %';
        },
      );

      if (download is Error<DownloadInfo>) {
        _goHome();
        return;
      }

      final file = (download as Success<DownloadInfo>).data;

      _updateProgress(value: 1, message: 'Launching installer...');

      await _updater.install(apkPath: file.localFilePath);
    } catch (_) {
      _goHome();
    }
  }

  void _updateProgress({required double value, required String message}) {
    progress.value = value;
    statusText.value = message;
  }

  void _goHome() {
    Get.offNamed(Routes.aHome);
  }
}
