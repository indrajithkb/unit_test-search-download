import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'endpoints.dart';
import 'exceptions.dart';
import 'secure_storage_helper.dart';

enum RequestType {
  delete,
  get,
  patch,
  post,
  put,
}

enum FormRequestType {
  raw,
  formData,
}

class NetworkAdapter {
  static final NetworkAdapter shared = NetworkAdapter._privateConstructor();
  NetworkAdapter._privateConstructor();

  Future<dynamic> send({
    EndPoint? endPoint,
    Map<String, dynamic>? params,
    String? id,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var client = http.Client();
    // HttpClientWithMiddleware.build(middlewares: [
    //   HttpLogger(logLevel: LogLevel.BODY),
    // ]);
    Map<String, String>? headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      // "version": "v2",
      // "tms-orgid": "238d948d-85ad-4385-a44c-3a57a8e8f980"
    };
    if (endPoint?.shouldAddToken == true) {
      headers = {
        // "tms-orgid": "238d948d-85ad-4385-a44c-3a57a8e8f980",
        "Accept": "application/json",
        "Content-Type": "application/json",
        // "version": "v2",
        // 'Authorization': 'Bearer ${await SecureStorageHelper.shared.getToken()}'
      };
    }

    // if (params != null) {
    //   if (defaultTargetPlatform == TargetPlatform.iOS ||
    //       defaultTargetPlatform == TargetPlatform.android) {
    //     params["platform"] = Platform.isAndroid ? "android" : "ios";
    //   } else if (defaultTargetPlatform == TargetPlatform.linux ||
    //       defaultTargetPlatform == TargetPlatform.macOS ||
    //       defaultTargetPlatform == TargetPlatform.windows) {
    //     // Some desktop specific code there
    //   } else {
    //     // Some web specific code there
    //   }
    // }
    http.Response response;
    String url = "";
    if (id != null) {
      url = endPoint!.cleanUrlWith(id);
    } else {
      url = endPoint!.url;
    }

    try {
      var uri;

      uri = Uri.https(ApiConstants.baseUrl, url, params ?? {});

      switch (endPoint.requestType) {
        case RequestType.delete:
          response = await client.delete(uri, headers: headers);
          break;
        case RequestType.get:
          response = await client.get(uri, headers: headers);
          break;
        case RequestType.patch:
          response = await client.patch(uri, headers: headers);
          break;
        case RequestType.post:
          var uri = Uri.https(ApiConstants.baseUrl, url, {});
          response = await client.post(
            uri,
            headers: headers,
            body: json.encode(params),
          );
          break;
        case RequestType.put:
          response = await client.put(uri, headers: headers);
          break;
      }
    } on SocketException catch (exception) {
      debugPrint(exception.message);
      return 'ERROR:${exception.message}'; // If response is available.
    }
    // print(response.body);
    return checkAndReturnResponse(response);
  }

  dynamic checkAndReturnResponse(http.Response response) {
    String? description; // App specific handling!
    Map<String, dynamic> jsonResponse = {};
    try {
      // debugPrint(response.body);
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return response.body;
    }
    description =
        jsonResponse.containsKey('message') ? jsonResponse['message'] : null;
    switch (response.statusCode) {
      case 200:
      case 201:
        // Null check for response.data
        if (jsonResponse.isEmpty) {
          throw FetchDataException(
              'Returned response data is null : ${response.reasonPhrase}');
        }
        return jsonResponse;
      case 400:
        throw BadRequestException(description ?? response.reasonPhrase);
      case 401:
      case 403:
        throw UnauthorizedException(description ?? response.reasonPhrase);
      case 404:
        throw NotFoundException(description ?? response.reasonPhrase);
      case 500:
        throw InternalServerException(description ?? response.reasonPhrase);
      default:
        throw FetchDataException(
            "Unknown error occurred\n\nerror Code: ${response.statusCode}  error: ${response.reasonPhrase}");
    }
  }
}
