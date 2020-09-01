import 'package:flutter_chatbox/repository/user_repository.dart';
import 'package:flutter_chatbox/services/fake_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_storage_service.dart';
import 'package:flutter_chatbox/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
}
