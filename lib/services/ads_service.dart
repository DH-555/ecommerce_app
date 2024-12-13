import 'package:appwrite/appwrite.dart';

class AdsService {
  final Client client;
  final Databases databases;

  // Constructor to initialize Appwrite client and databases
  AdsService()
      : client = Client(),
        databases = Databases(Client()) {
    client.setEndpoint('https://cloud.appwrite.io/v1')  // Appwrite endpoint (use the correct endpoint)
      .setProject('643589d049746360e283')  // Appwrite Project ID (replace with yours)
      .setSelfSigned(status: true);  // Set to true if using a self-signed certificate (for local testing)
  }

  // Fetch image URLs from a single document
  Future<List<String>> fetchAds() async {
    try {
      final response = await databases.getDocument(
        databaseId: '6680fb56002d0990b78c',  // Appwrite Database ID (replace with yours)
        collectionId: '672e0eb90016ce82212a', // Appwrite Collection ID (replace with yours)
        documentId: '672e0f30000c6b1b2be5',       // Replace with the actual Document ID
      );

      // Ensure 'image_urls' exists and is a list of strings
      List<String> imageUrls = List<String>.from(response.data['image_urls'] ?? []);
      return imageUrls;
    } catch (e) {
      print('Error fetching ads: $e');
      return [];  // Return an empty list if there's an error
    }
  }
}
