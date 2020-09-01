import 'dart:io';

abstract class StorageBase {
  Future<String> uploadImage(String userID, String fileType, File file);
}
