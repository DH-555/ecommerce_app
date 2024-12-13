// services/banners_service.dart
import 'package:ecommerce_app/models/banner_model.dart';

import 'package:appwrite/appwrite.dart';

class BannersService {
  final Client client;
  final Databases databases;

  BannersService()
      : client = Client()
          .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
          .setProject('643589d049746360e283'), // Your project ID
        databases = Databases(Client()
          .setEndpoint('https://cloud.appwrite.io/v1')
          .setProject('643589d049746360e283'));

  Future<List<BannerModel>> fetchBanners() async {
    final response = await databases.listDocuments(
      databaseId: '6680fb56002d0990b78c',
      collectionId: '672e0eb90016ce82212a',
    );

    return response.documents.map((doc) => BannerModel.fromJson(doc.data)).toList();
  }
}