// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorageHelper {
//   static final SecureStorageHelper shared =
//       SecureStorageHelper._privateConstructor();

//   SecureStorageHelper._privateConstructor();

//   AndroidOptions _getAndroidOptions() => const AndroidOptions(
//       // encryptedSharedPreferences: false,
//       );

//   final storage = const FlutterSecureStorage();

//   final String token = '';

//   Future<void> setToken(String token) async {
//     // storage.delete(key: 'token');
//     await storage.write(
//         key: 'token', value: token, aOptions: _getAndroidOptions());
//   }

//   Future<void> removeToken() async {
//     // storage.delete(key: 'token');
//     await storage.delete(
//         key: 'token', aOptions: _getAndroidOptions());
//   }



//   Future<String> getToken() async {
//     var token = await storage.read(key: 'token');
//     return token ?? '';
//   }
// }
