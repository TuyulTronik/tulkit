// splashscreen_controller.dart

import 'dart:async';

import 'package:flutter_apk_updater/flutter_apk_updater.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulkit/main_lib.dart';
import 'package:tulkit/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  // ============================================================
  // OBSERVABLES
  // ============================================================
  final progress = 0.0.obs;
  final statusText = 'Memulai aplikasi...'.obs;
  final isDownloading = false.obs;
  final isInstalling = false.obs;

  // ============================================================
  // DEPENDENCIES
  // ============================================================
  late final ApkUpdater _updater;

  // ============================================================
  // STATE
  // ============================================================
  bool _isNavigating = false;
  Timer? _progressTimer;
  bool _isChecking = false; // ✅ Sekarang digunakan

  // Download / Update info
  DownloadInfo? _downloadInfo;
  UpdateInfo? _pendingUpdateInfo; // ✅ Sekarang digunakan

  // SharedPreferences keys
  static const String _cancelledUpdateKey = 'cancelled_update_version';
  static const String _pendingApkPathKey = 'pending_apk_path';
  static const String _pendingApkVersionKey = 'pending_apk_version';

  // ============================================================
  // LIFECYCLE
  // ============================================================
  @override
  void onInit() {
    super.onInit();

    _updater = ApkUpdater(
      config: const ApkUpdaterConfig(
        owner: 'TuyulTronik',
        repository: 'tulkit',
        apkPattern: 'release',
      ),
      timeout: const Duration(seconds: 60),
    );

    _startSplashSequence();
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    _updater.cancelDownload();

    // ✅ Gunakan _pendingUpdateInfo untuk logging
    if (_pendingUpdateInfo != null) {
      print(
        '⚠️ Splashscreen ditutup dengan update pending: ${_pendingUpdateInfo!.latestVersion}',
      );
    }

    super.onClose();
  }

  // ============================================================
  // SHAREDPREFERENCES HELPERS
  // ============================================================
  Future<void> _saveCancelledUpdate(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cancelledUpdateKey, version);
  }

  Future<bool> _isUpdateCancelled(String version) async {
    final prefs = await SharedPreferences.getInstance();
    final cancelled = prefs.getString(_cancelledUpdateKey);
    return cancelled == version;
  }

  Future<void> _clearCancelledUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cancelledUpdateKey);
  }

  Future<void> _savePendingInstall(String apkPath, String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingApkPathKey, apkPath);
    await prefs.setString(_pendingApkVersionKey, version);
  }

  Future<Map<String, String?>?> _getPendingInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_pendingApkPathKey);
    final version = prefs.getString(_pendingApkVersionKey);
    if (path != null && version != null) {
      return {'path': path, 'version': version};
    }
    return null;
  }

  Future<void> _clearPendingInstall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingApkPathKey);
    await prefs.remove(_pendingApkVersionKey);
  }

  // ============================================================
  // MAIN SEQUENCE
  // ============================================================
  void _startSplashSequence() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_isNavigating && progress.value < 0.2) {
        progress.value += 0.005;
      } else if (progress.value >= 0.2) {
        timer.cancel();
        _checkPendingInstall();
      }
    });
  }

  Future<void> _checkPendingInstall() async {
    final pending = await _getPendingInstall();

    if (pending != null) {
      statusText.value = 'Update siap dipasang';
      await _animateProgressTo(
        0.5,
        duration: const Duration(milliseconds: 300),
      );
      _showPendingInstallDialog(pending['path']!, pending['version']!);
      return;
    }

    await _checkUpdateWithRetry();
  }

  // ============================================================
  // PENDING INSTALL DIALOG
  // ============================================================
  void _showPendingInstallDialog(String apkPath, String version) {
    Get.dialog<bool>(
      AlertDialog(
        title: const Text('Update Siap Dipasang'),
        content: Text(
          'Versi $version telah diunduh.\nApakah Anda ingin menginstall sekarang?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Install Sekarang'),
          ),
        ],
      ),
    ).then((shouldInstall) async {
      if (shouldInstall == true) {
        await _clearPendingInstall();
        await _doInstall(apkPath);
      } else {
        await _navigateToHome();
      }
    });
  }

  // ============================================================
  // CHECK UPDATE - Mengembalikan Result
  // ============================================================
  
  Future<Result<UpdateInfo>> _checkUpdate() async {
    try {
      _isChecking = true;
      statusText.value = 'Memeriksa pembaruan...';

      await _animateProgressTo(0.4, duration: const Duration(seconds: 1));

      final result = await _updater.check();

      if (result is Error<UpdateInfo>) {
        statusText.value = _getUserFriendlyError(result.failure);
        return Error(result.failure); // ✅ Return error
      }

      final updateInfo = (result as Success<UpdateInfo>).data;

      if (!updateInfo.hasUpdate) {
        statusText.value = 'Aplikasi sudah versi terbaru';
        await _animateProgressTo(
          0.6,
          duration: const Duration(milliseconds: 300),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        await _animateProgressTo(
          1.0,
          duration: const Duration(milliseconds: 500),
        );
        await _navigateToHome();
        return Success(updateInfo); // ✅ Return success
      }

      _pendingUpdateInfo = updateInfo;
      print(
        '📱 Update tersedia: ${updateInfo.currentVersion} → ${updateInfo.latestVersion}',
      );

      final isCancelled = await _isUpdateCancelled(updateInfo.latestVersion);

      if (isCancelled) {
        statusText.value =
            'Pembaruan versi ${updateInfo.latestVersion} tersedia.';
        await _animateProgressTo(
          0.6,
          duration: const Duration(milliseconds: 300),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        await _animateProgressTo(
          1.0,
          duration: const Duration(milliseconds: 500),
        );
        await _navigateToHome();
        return Success(updateInfo);
      }

      statusText.value = 'Versi ${updateInfo.latestVersion} tersedia';
      await _animateProgressTo(
        0.4,
        duration: const Duration(milliseconds: 300),
      );

      final downloadSuccess = await _downloadUpdate(updateInfo);

      if (!downloadSuccess) {
        await _animateProgressTo(
          0.6,
          duration: const Duration(milliseconds: 300),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        await _animateProgressTo(
          1.0,
          duration: const Duration(milliseconds: 500),
        );
        await _navigateToHome();
        return Success(updateInfo); // ✅ Return success (user tetap lanjut)
      }

      await _animateProgressTo(
        0.9,
        duration: const Duration(milliseconds: 300),
      );

      final shouldInstall = await _showInstallDialog(updateInfo);

      if (!shouldInstall) {
        await _saveCancelledUpdate(updateInfo.latestVersion);
        statusText.value = 'Update dibatalkan. Akan diingatkan nanti.';
        await _animateProgressTo(
          0.6,
          duration: const Duration(milliseconds: 300),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        await _animateProgressTo(
          1.0,
          duration: const Duration(milliseconds: 500),
        );
        await _navigateToHome();
        return Success(updateInfo);
      }

      await _clearCancelledUpdate();
      await _doInstall(_downloadInfo!.localFilePath);

      return Success(updateInfo);
    } catch (e) {
      statusText.value = 'Error: $e';
      return Error(
        Failure(code: 'updater.exception', message: e.toString(), exception: e),
      );
    } finally {
      _isChecking = false;
      print('🔍 Check update finished');
    }
  }

  // ============================================================
  // UPDATE CHECK WITH RETRY - SMART RETRY
  // ============================================================
  Future<void> _checkUpdateWithRetry({int retryCount = 0}) async {
    const maxRetries = 2;

    final result = await _checkUpdate();

    // ✅ Cek apakah error dan bisa di-retry
    final isNetworkError =
        result is Error<UpdateInfo> &&
        (result.failure.code == 'github.network' ||
            result.failure.code == 'download.network' ||
            result.failure.code == 'github.request_failed');

    if (isNetworkError && retryCount < maxRetries) {
      statusText.value =
          'Koneksi terganggu. Mencoba ulang... (${retryCount + 1}/$maxRetries)';
      await Future.delayed(const Duration(seconds: 2));
      await _checkUpdateWithRetry(retryCount: retryCount + 1);
      return;
    }

    // ✅ Jika error permanen (bukan network error)
    if (result is Error<UpdateInfo>) {
      statusText.value = _getUserFriendlyError(result.failure);
      await _animateProgressTo(
        0.6,
        duration: const Duration(milliseconds: 300),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await _animateProgressTo(
        1.0,
        duration: const Duration(milliseconds: 500),
      );
      await _navigateToHome();
    }
  }

  // ============================================================
  // DOWNLOAD
  // ============================================================
  Future<bool> _downloadUpdate(UpdateInfo updateInfo) async {
    try {
      isDownloading.value = true;

      final downloadResult = await _updater.download(
        updateInfo: updateInfo,
        onProgress: (downloadInfo) {
          final downloadProgress = downloadInfo.progress;
          final mappedProgress = 0.4 + (downloadProgress * 0.5);
          progress.value = mappedProgress;

          statusText.value =
              'Mengunduh ${(downloadProgress * 100).toStringAsFixed(0)}%';
        },
      );

      isDownloading.value = false;

      if (downloadResult is Error<DownloadInfo>) {
        statusText.value = _getUserFriendlyError(downloadResult.failure);
        return false;
      }

      _downloadInfo = (downloadResult as Success<DownloadInfo>).data;

      await _animateProgressTo(
        0.9,
        duration: const Duration(milliseconds: 300),
      );

      return true;
    } catch (e) {
      isDownloading.value = false;
      statusText.value = 'Download gagal: $e';
      return false;
    }
  }

  // ============================================================
  // INSTALL DIALOG
  // ============================================================
  Future<bool> _showInstallDialog(UpdateInfo updateInfo) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Versi Baru Telah Diunduh'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Versi ${updateInfo.latestVersion} siap dipasang.'),
                const SizedBox(height: 8),
                const Text('Apakah Anda ingin menginstall sekarang?'),
                if (updateInfo.release.releaseNotes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Release Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    updateInfo.release.releaseNotes,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _savePendingInstall(
                    _downloadInfo!.localFilePath,
                    updateInfo.latestVersion,
                  );
                  Get.back(result: false);
                },
                child: const Text('Nanti'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text('Install Sekarang'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ============================================================
  // INSTALL EXECUTION
  // ============================================================
  Future<void> _doInstall(String apkPath) async {
    statusText.value = 'Menyiapkan instalasi...';
    await _animateProgressTo(0.95, duration: const Duration(milliseconds: 300));

    final hasPermission = await _updater.canRequestPackageInstalls();

    if (!hasPermission) {
      final shouldOpenSettings = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Izin Instalasi Diperlukan'),
          content: const Text(
            'Untuk menginstall update, aplikasi memerlukan izin '
            'untuk menginstall dari sumber tidak dikenal.\n\n'
            'Apakah Anda ingin membuka pengaturan sekarang?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Buka Pengaturan'),
            ),
          ],
        ),
      );

      if (shouldOpenSettings == true) {
        await _updater.openInstallSettings();
        await Future.delayed(const Duration(seconds: 2));
        await _doInstall(apkPath);
        return;
      }

      statusText.value = 'Instalasi dibatalkan';
      await _animateProgressTo(
        0.6,
        duration: const Duration(milliseconds: 300),
      );
      await _navigateToHome();
      return;
    }

    final installResult = await _updater.install(apkPath: apkPath);
  

    if (installResult is Error<void>) {
      statusText.value = _getUserFriendlyError(installResult.failure);
      await _animateProgressTo(
        0.6,
        duration: const Duration(milliseconds: 300),
      );
      await _navigateToHome();
      return;
    }

    statusText.value = 'Membuka installer...';
    await _animateProgressTo(0.95, duration: const Duration(milliseconds: 200));
  }

  // ============================================================
  // NAVIGATION
  // ============================================================
  Future<void> _navigateToHome() async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Future.delayed(const Duration(milliseconds: 300));

    if (Get.isRegistered<SplashscreenController>()) {
      Get.offAllNamed(Routes.aHome);
    }
  }

  // ============================================================
  // PROGRESS ANIMATION
  // ============================================================
  Future<void> _animateProgressTo(
    double target, {
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    if (_isNavigating) return;
    if (target <= progress.value) return;

    final start = progress.value;
    final difference = target - start;
    final steps = 20;
    final stepDuration = duration ~/ steps;
    final stepValue = difference / steps;

    for (int i = 1; i <= steps; i++) {
      if (!_isChecking && progress.value < 0.4) continue;
      progress.value = start + (stepValue * i);
      await Future.delayed(stepDuration);
    }

    progress.value = target;
  }

  // ============================================================
  // USER-FRIENDLY ERROR
  // ============================================================
  String _getUserFriendlyError(Failure failure) {
    switch (failure.code) {
      case 'github.network':
        return 'Gagal terhubung ke server. Periksa koneksi internet.';
      case 'github.unauthorized':
        return 'Token GitHub tidak valid. Hubungi tim IT.';
      case 'github.not_found':
        return 'Tidak ada pembaruan baru yang tersedia';
      case 'download.network':
        return 'Koneksi terputus saat download. Coba lagi nanti.';
      case 'storage.insufficient':
        return 'Storage tidak mencukupi. Hapus file yang tidak diperlukan.';
      case 'permission_denied':
        return 'Izin instalasi diperlukan. Buka pengaturan untuk mengizinkan.';
      case 'checksum.mismatch':
        return 'File APK rusak. Coba download ulang.';
      default:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Terjadi kesalahan. Coba lagi nanti.';
    }
  }

  // ============================================================
  // PUBLIC METHODS
  // ============================================================
  Future<void> retryCheck() async {
    if (_isNavigating) return;
    _isNavigating = false;
    _downloadInfo = null;
    _pendingUpdateInfo = null;
    progress.value = 0.0;
    await _checkUpdateWithRetry();
  }
}
