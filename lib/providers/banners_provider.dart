// providers/banners_provider.dart
import 'package:ecommerce_app/models/banner_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/services/banners_service.dart';


final bannersProvider = FutureProvider<List<BannerModel>>((ref) async {
  final bannersService = BannersService();
  return await bannersService.fetchBanners();
});