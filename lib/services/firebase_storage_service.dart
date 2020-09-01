import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chatbox/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadImage(String userID, String fileType, File file) async {
    _storageReference = _firebaseStorage.ref().child(userID).child(fileType);
    var uploadTask = _storageReference.putFile(file);
    var url = (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }
}
