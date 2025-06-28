import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import '../services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  final double? height;
  final EdgeInsets? margin;
  final bool showBackground;
  
  const BannerAdWidget({
    super.key,
    this.height,
    this.margin,
    this.showBackground = true,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    setState(() {
      _isLoading = true;
    });
    
    final adService = Get.find<AdService>();
    _bannerAd = await adService.loadBannerAd();
    
    if (mounted) {
      setState(() {
        _isLoaded = _bannerAd != null;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height ?? 60,
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      );
    }

    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: widget.height ?? 60,
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: widget.showBackground ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
} 