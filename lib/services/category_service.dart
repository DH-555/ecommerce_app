// services/category_service.dart
import 'package:ecommerce_app/models/category_model.dart';
import 'package:appwrite/appwrite.dart';

class CategoryService {
  final Client client;
  final Databases databases;

  CategoryService()
      : client = Client()
          .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
          .setProject('643589d049746360e283'), // Your project ID
        databases = Databases(Client()
          .setEndpoint('https://cloud.appwrite.io/v1')
          .setProject('643589d049746360e283'));

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await databases.listDocuments(
      databaseId: '6680fb56002d0990b78c',
      collectionId: '67384236001e12a0a3af',
    );

    return response.documents.map((doc) => CategoryModel.fromJson(doc.data)).toList();
  }
}