// banner_widget.dart
import 'package:ecommerce_app/models/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerWidget extends StatelessWidget {
  final AsyncValue<List<BannerModel>> bannersAsyncValue;
  final PageController bannerController;

  const BannerWidget({
    Key? key,
    required this.bannersAsyncValue,
    required this.bannerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bannersAsyncValue.when(
      data: (banners) => _buildBannerContent(context, banners),
      loading: () => _buildShimmerLoader(),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildBannerContent(BuildContext context, List<BannerModel> banners) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: bannerController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return _buildBannerImage(banners[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildPageIndicator(banners.length),
      ],
    );
  }

  Widget _buildBannerImage(BannerModel banner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: banner.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildShimmerLoader(),
          errorWidget: (context, url, error) => _buildErrorImage(),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int count) {
    return Center(
      child: SmoothPageIndicator(
        controller: bannerController,
        count: count,
        effect: const WormEffect(
          dotColor: Colors.grey,
          activeDotColor: Colors.deepPurple,
          dotHeight: 8,
          dotWidth: 8,
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            'Error: ${error.toString()}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 50,
        ),
      ),
    );
  }
}