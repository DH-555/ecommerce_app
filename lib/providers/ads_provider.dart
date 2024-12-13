import 'package:ecommerce_app/services/ads_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final adsServiceProvider = Provider<AdsService>((ref) {
  return AdsService();
});

final adsProvider = FutureProvider<List<String>>((ref) async {
  final adsService = ref.read(adsServiceProvider);
  return await adsService.fetchAds();
});
