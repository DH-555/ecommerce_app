import 'package:ecommerce_app/providers/ads_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdsWidget extends ConsumerWidget {
  final double height;
  final double aspectRatio;
  final BorderRadius borderRadius;

  const AdsWidget({
    Key? key,
    this.height = 200,
    this.aspectRatio = 16 / 9,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsyncValue = ref.watch(adsProvider);

    return adsAsyncValue.when(
      data: (ads) {
        if (ads.isEmpty) {
          return _buildEmptyState();
        }

        return CarouselSlider.builder(
          itemCount: ads.length,
          itemBuilder: (context, index, realIndex) {
            return _buildAdItem(ads[index]);
          },
          options: CarouselOptions(
            height: height,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: aspectRatio,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 5),
            pauseAutoPlayOnTouch: true,
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(),
    );
  }

  Widget _buildAdItem(String adUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: adUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorImage(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 10),
          Text(
            "No ads available",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red[400],
          ),
          const SizedBox(height: 10),
          Text(
            "Failed to load ads",
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[600],
          size: 50,
        ),
      ),
    );
  }
}