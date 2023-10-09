import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sampleapi/NetworkApi/adapter.dart';
import 'package:sampleapi/NetworkApi/endpoints.dart';
import 'package:sampleapi/model/user_model.dart';

class UserRepo {

  // final http.Client client;
  // UserRepo(this.client);
  String baseUrl = 'https://reqres.in/api/users?page=2';

  Future<UserModel> getApiData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      print(response.body);
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data from the API');
    }
  }
}

// class UserRepo {
//   final NetworkAdapter _networkAdapter = NetworkAdapter.shared;

//   Future<UserModel> getApiData() async {
//     try {
//       // Call the GET request using the NetworkAdapter
//       var response = await _networkAdapter.send(
//         endPoint: EndPoint.user, // Replace with the actual GET endpoint
//         // You can add more parameters as needed, such as headers or query parameters
//       );
//       print(response);
//       var res = UserModel.fromJson(response);
//       return res;
//     } catch (e) {
//       print(e);
//       throw Exception('Error: $e'); // Handle network or other exceptions
//     }
//   }
// }
