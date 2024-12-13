import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';

// Appwrite Client
final client = Client()
    .setEndpoint(AppConstants.endpoint) // Your Appwrite endpoint
    .setProject(AppConstants.projectId); // Your project ID

// Provide Appwrite Databases
final appwriteDatabaseProvider = Provider<Databases>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

// Provide Appwrite Account
final appwriteAccountProvider = Provider<Account>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});
