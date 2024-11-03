import 'dart:developer';
import 'dart:io';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_dialog.dart';

class AdHelper {
  static void init() {
    // Initialize only on Android and iOS
    if (Platform.isAndroid || Platform.isIOS) {
      EasyAudienceNetwork.init(
        testMode:
            true, // for testing purpose but comment it before making the app live
      );
    } else {
      log('AdHelper.init() skipped: Platform not supported for ads.');
    }
  }

  static void showInterstitialAd(VoidCallback onComplete) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Show loading
      MyDialog.showLoadingDialog();

      final interstitialAd = InterstitialAd(InterstitialAd.testPlacementId);

      interstitialAd.listener = InterstitialAdListener(onLoaded: () {
        // Hide loading
        Get.back();
        onComplete();

        interstitialAd.show();
      }, onDismissed: () {
        interstitialAd.destroy();
      }, onError: (i, e) {
        // Hide loading
        Get.back();
        onComplete();

        log('interstitial error: $e');
      });

      interstitialAd.load();
    } else {
      log('showInterstitialAd() skipped: Platform not supported for ads.');
      // Optionally, you can call onComplete() here if you want to proceed immediately
      onComplete();
    }
  }

  static Widget nativeAd() {
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(
        child: NativeAd(
          placementId: NativeAd.testPlacementId,
          adType: NativeAdType.NATIVE_AD,
          keepExpandedWhileLoading: false,
          expandAnimationDuraion: 1000,
          listener: NativeAdListener(
            onError: (code, message) => log('Native ad error: $message'),
            onLoaded: () => log('Native ad loaded'),
            onClicked: () => log('Native ad clicked'),
            onLoggingImpression: () => log('Native ad logging impression'),
            onMediaDownloaded: () => log('Native ad media downloaded'),
          ),
        ),
      );
    } else {
      log('nativeAd() skipped: Platform not supported for ads.');
      // Return an empty container or any placeholder widget
      return const SizedBox.shrink();
    }
  }

  static Widget nativeBannerAd() {
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(
        child: NativeAd(
          placementId: NativeAd.testPlacementId,
          adType: NativeAdType.NATIVE_BANNER_AD,
          bannerAdSize: NativeBannerAdSize.HEIGHT_100,
          keepExpandedWhileLoading: false,
          height: 100,
          expandAnimationDuraion: 1000,
          listener: NativeAdListener(
            onError: (code, message) => log('Native banner ad error: $message'),
            onLoaded: () => log('Native banner ad loaded'),
            onClicked: () => log('Native banner ad clicked'),
            onLoggingImpression: () =>
                log('Native banner ad logging impression'),
            onMediaDownloaded: () => log('Native banner ad media downloaded'),
          ),
        ),
      );
    } else {
      log('nativeBannerAd() skipped: Platform not supported for ads.');
      // Return an empty container or any placeholder widget
      return const SizedBox.shrink();
    }
  }
}
