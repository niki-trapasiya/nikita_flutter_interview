import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/core/constants/app_string.dart';
import '../constants/ad_config.dart';

class AdService extends GetxService {
  static AdService get to => Get.find();
  
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;
  
  final RxBool isRewardedAdLoaded = false.obs;
  final RxBool isInterstitialAdLoaded = false.obs;
  final RxBool isBannerAdLoaded = false.obs;

  int _interstitialAdCount = 0;
  int _rewardedAdCount = 0;
  DateTime? _lastAdShown;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAds();
    monitorConnectivityAndReloadAd();
  }
  void monitorConnectivityAndReloadAd() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none && _rewardedAd == null) {
        _loadRewardedAd();
        _loadInterstitialAd();
      }
    });
  }

  Future<void> _initializeAds() async {
    await MobileAds.instance.initialize();
    _loadRewardedAd();
    _loadInterstitialAd();
  }
  
  Future<void> _loadRewardedAd() async {
    try {
      await RewardedAd.load(
        adUnitId: AdConfig.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            isRewardedAdLoaded.value = true;
            _setupRewardedAdCallbacks();
          },
          onAdFailedToLoad: (error) {
            print('Rewarded ad failed to load: $error');
            isRewardedAdLoaded.value = false;
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded ad: $e');
      isRewardedAdLoaded.value = false;
    }
  }
  
  void _setupRewardedAdCallbacks() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd(); // Load next ad
      },
    );
  }
  
  bool _canShowRewardedAd() {
    return true;
  }
  
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    required Function() onFailed,
  }) async {
    if (!_canShowRewardedAd()) {
      onFailed();
      return false;
    }
    
    if (_rewardedAd == null || !isRewardedAdLoaded.value) {
      onFailed();
      return false;
    }
    
    _rewardedAdCount++;
    _lastAdShown = DateTime.now();
    
    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        onRewarded();
      },
    );
    
    return true;
  }
  
  Future<void> _loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: AdConfig.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            isInterstitialAdLoaded.value = true;
            _setupInterstitialAdCallbacks();
          },
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
            isInterstitialAdLoaded.value = false;
          },
        ),
      );
    } catch (e) {
      print('Error loading interstitial ad: $e');
      isInterstitialAdLoaded.value = false;
    }
  }
  
  void _setupInterstitialAdCallbacks() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadInterstitialAd();
      },
    );
  }
  
  bool _canShowInterstitialAd() {
    return true;
  }
  
  Future<bool> showInterstitialAd() async {
    if (!_canShowInterstitialAd()) {
      return false;
    }
    
    if (_interstitialAd == null || !isInterstitialAdLoaded.value) {
      return false;
    }
    
    _interstitialAdCount++;
    _lastAdShown = DateTime.now();
    
    await _interstitialAd!.show();
    return true;
  }
  
  Future<BannerAd?> loadBannerAd() async {
    try {
      _bannerAd = BannerAd(
        adUnitId: AdConfig.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isBannerAdLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            print('Banner ad failed to load: $error');
            isBannerAdLoaded.value = false;
            ad.dispose();
          },
        ),
      );
      
      await _bannerAd!.load();
      return _bannerAd;
    } catch (e) {
      print('Error loading banner ad: $e');
      isBannerAdLoaded.value = false;
      return null;
    }
  }
  
  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    isBannerAdLoaded.value = false;
  }
  
  Future<void> showRewardedVideoAdForTaskCompletion() async {
    if (!AdConfig.showRewardedOnTaskCompletion) return;
    
    await showRewardedAd(
      onRewarded: () {
      },
      onFailed: () {
        Get.snackbar(
          AppString.adNotAvailable,
          AppString.adNotAvailableDetail,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }
  
  Future<void> showInterstitialAdOnNavigation() async {
    if (!AdConfig.showInterstitialOnNavigation) return;
    await showInterstitialAd();
  }
  
  Future<void> showInterstitialAdOnTaskEdit() async {
    if (!AdConfig.showInterstitialOnTaskEdit) return;
    await showInterstitialAd();
  }
  
  Future<void> showInterstitialAdOnTaskSave() async {
    if (!AdConfig.showInterstitialOnTaskSave) return;
    await showInterstitialAd();
  }
  
  @override
  void onClose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
    super.onClose();
  }
} 