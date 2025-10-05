import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';

/// Ad loading result
enum AdLoadResult {
  loaded,
  failed,
  alreadyLoaded,
}

/// Singleton helper for managing Google Mobile Ads
class AdsHelper {
  static AdsHelper? _instance;

  // Private constructor
  AdsHelper._();

  /// Get singleton instance
  static AdsHelper get instance {
    _instance ??= AdsHelper._();
    return _instance!;
  }

  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Ad loading states
  bool _isBannerLoaded = false;
  bool _isInterstitialLoaded = false;
  bool _isRewardedLoaded = false;

  // Ad unit IDs
  static const String _bannerAdUnitId = AppConstants.BANNER_AD_UNIT_ID;
  static const String _interstitialAdUnitId = AppConstants.INTERSTITIAL_AD_UNIT_ID;
  static const String _rewardedAdUnitId = AppConstants.REWARDED_AD_UNIT_ID;

  /// Initialize Google Mobile Ads
  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      print('Google Mobile Ads initialized successfully');
    } catch (e) {
      print('Error initializing Google Mobile Ads: $e');
      throw Exception('Failed to initialize Google Mobile Ads: $e');
    }
  }

  /// Get banner ad instance
  BannerAd? get bannerAd => _bannerAd;

  /// Check if banner ad is loaded
  bool get isBannerLoaded => _isBannerLoaded;

  /// Check if interstitial ad is loaded
  bool get isInterstitialLoaded => _isInterstitialLoaded;

  /// Check if rewarded ad is loaded
  bool get isRewardedLoaded => _isRewardedLoaded;

  /// Load banner ad
  Future<AdLoadResult> loadBannerAd() async {
    try {
      if (_isBannerLoaded) {
        return AdLoadResult.alreadyLoaded;
      }

      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Banner ad loaded successfully');
            _isBannerLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            print('Banner ad failed to load: $error');
            _isBannerLoaded = false;
            ad.dispose();
          },
          onAdOpened: (ad) => print('Banner ad opened'),
          onAdClosed: (ad) => print('Banner ad closed'),
          onAdImpression: (ad) => print('Banner ad impression recorded'),
        ),
      );

      await _bannerAd!.load();
      return _isBannerLoaded ? AdLoadResult.loaded : AdLoadResult.failed;
    } catch (e) {
      print('Error loading banner ad: $e');
      return AdLoadResult.failed;
    }
  }

  /// Load interstitial ad
  Future<AdLoadResult> loadInterstitialAd() async {
    try {
      if (_isInterstitialLoaded) {
        return AdLoadResult.alreadyLoaded;
      }

      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('Interstitial ad loaded successfully');
            _interstitialAd = ad;
            _isInterstitialLoaded = true;
            
            // Set full screen content callback
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                print('Interstitial ad showed full screen content');
              },
              onAdDismissedFullScreenContent: (ad) {
                print('Interstitial ad dismissed');
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialLoaded = false;
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('Interstitial ad failed to show: $error');
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialLoaded = false;
              },
            );
          },
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
            _isInterstitialLoaded = false;
          },
        ),
      );

      return AdLoadResult.loaded;
    } catch (e) {
      print('Error loading interstitial ad: $e');
      return AdLoadResult.failed;
    }
  }

  /// Load rewarded ad
  Future<AdLoadResult> loadRewardedAd() async {
    try {
      if (_isRewardedLoaded) {
        return AdLoadResult.alreadyLoaded;
      }

      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            print('Rewarded ad loaded successfully');
            _rewardedAd = ad;
            _isRewardedLoaded = true;
            
            // Set full screen content callback
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                print('Rewarded ad showed full screen content');
              },
              onAdDismissedFullScreenContent: (ad) {
                print('Rewarded ad dismissed');
                ad.dispose();
                _rewardedAd = null;
                _isRewardedLoaded = false;
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('Rewarded ad failed to show: $error');
                ad.dispose();
                _rewardedAd = null;
                _isRewardedLoaded = false;
              },
            );
          },
          onAdFailedToLoad: (error) {
            print('Rewarded ad failed to load: $error');
            _isRewardedLoaded = false;
          },
        ),
      );

      return AdLoadResult.loaded;
    } catch (e) {
      print('Error loading rewarded ad: $e');
      return AdLoadResult.failed;
    }
  }

  /// Show interstitial ad after game completion
  Future<bool> showInterstitialAfterCompletion() async {
    try {
      if (!_isInterstitialLoaded) {
        final loadResult = await loadInterstitialAd();
        if (loadResult != AdLoadResult.loaded) {
          print('Failed to load interstitial ad for completion');
          return false;
        }
      }

      if (_interstitialAd != null) {
        await _interstitialAd!.show();
        return true;
      }

      return false;
    } catch (e) {
      print('Error showing interstitial ad after completion: $e');
      return false;
    }
  }

  /// Show rewarded ad for hints
  Future<bool> showRewardedAdForHint({
    required Function() onRewarded,
    required Function(String) onError,
  }) async {
    try {
      if (!_isRewardedLoaded) {
        final loadResult = await loadRewardedAd();
        if (loadResult != AdLoadResult.loaded) {
          onError('Failed to load rewarded ad');
          return false;
        }
      }

      if (_rewardedAd != null) {
        await _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {
            print('User earned reward: ${reward.amount} ${reward.type}');
            onRewarded();
          },
        );
        return true;
      }

      onError('No rewarded ad available');
      return false;
    } catch (e) {
      print('Error showing rewarded ad for hint: $e');
      onError('Error showing ad: $e');
      return false;
    }
  }

  /// Show rewarded ad for extra chances
  Future<bool> showRewardedAdForExtraChance({
    required Function() onRewarded,
    required Function(String) onError,
  }) async {
    try {
      if (!_isRewardedLoaded) {
        final loadResult = await loadRewardedAd();
        if (loadResult != AdLoadResult.loaded) {
          onError('Failed to load rewarded ad');
          return false;
        }
      }

      if (_rewardedAd != null) {
        await _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {
            print('User earned reward for extra chance: ${reward.amount} ${reward.type}');
            onRewarded();
          },
        );
        return true;
      }

      onError('No rewarded ad available');
      return false;
    } catch (e) {
      print('Error showing rewarded ad for extra chance: $e');
      onError('Error showing ad: $e');
      return false;
    }
  }

  /// Preload ads for better performance
  Future<void> preloadAds() async {
    try {
      print('Preloading ads...');
      
      // Load banner ad
      await loadBannerAd();
      
      // Load interstitial ad
      await loadInterstitialAd();
      
      // Load rewarded ad
      await loadRewardedAd();
      
      print('Ads preloading completed');
    } catch (e) {
      print('Error preloading ads: $e');
    }
  }

  /// Dispose banner ad
  void disposeBannerAd() {
    try {
      _bannerAd?.dispose();
      _bannerAd = null;
      _isBannerLoaded = false;
      print('Banner ad disposed');
    } catch (e) {
      print('Error disposing banner ad: $e');
    }
  }

  /// Dispose interstitial ad
  void disposeInterstitialAd() {
    try {
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialLoaded = false;
      print('Interstitial ad disposed');
    } catch (e) {
      print('Error disposing interstitial ad: $e');
    }
  }

  /// Dispose rewarded ad
  void disposeRewardedAd() {
    try {
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _isRewardedLoaded = false;
      print('Rewarded ad disposed');
    } catch (e) {
      print('Error disposing rewarded ad: $e');
    }
  }

  /// Dispose all ads
  void disposeAllAds() {
    disposeBannerAd();
    disposeInterstitialAd();
    disposeRewardedAd();
  }

  /// Check if ads are supported on current platform
  bool get isAdSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Get test device IDs for development
  List<String> get testDeviceIds {
    return [
      'TEST_DEVICE_ID_ANDROID',
      'TEST_DEVICE_ID_IOS',
    ];
  }

  /// Enable test ads for development
  void enableTestAds() {
    if (!isAdSupported) return;
    
    try {
      // This would typically be done during initialization
      // MobileAds.instance.updateRequestConfiguration(
      //   RequestConfiguration(testDeviceIds: testDeviceIds),
      // );
      print('Test ads enabled');
    } catch (e) {
      print('Error enabling test ads: $e');
    }
  }

  /// Check if user has disabled personalized ads
  Future<bool> hasUserDisabledPersonalizedAds() async {
    try {
      // This would check user's ad personalization settings
      // Implementation depends on how you handle user preferences
      return false;
    } catch (e) {
      print('Error checking personalized ads status: $e');
      return false;
    }
  }

  /// Request non-personalized ads
  AdRequest getNonPersonalizedAdRequest() {
    return const AdRequest(
      nonPersonalizedAds: true,
    );
  }

  /// Get personalized ad request
  AdRequest getPersonalizedAdRequest() {
    return const AdRequest();
  }
}
