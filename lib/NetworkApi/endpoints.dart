import 'adapter.dart';
import 'api_constants.dart';

enum EndPoint { 
  // appConfig, jokesCategories, home, login, alert,
   user }

extension URLExtension on EndPoint {
  String get url {
    switch (this) {
      // case EndPoint.appConfig:
      //   return ApiConstants.appConfig;
      // case EndPoint.jokesCategories:
      //   return ApiConstants.path + ApiConstants.jokesCategories;
      // case EndPoint.home:
      //   return ApiConstants.path + ApiConstants.appHome;
      // case EndPoint.login:
      //   return ApiConstants.path + ApiConstants.login;
      // case EndPoint.alert:
      //   return ApiConstants.path + ApiConstants.alert;
      case EndPoint.user:
        return ApiConstants.path + ApiConstants.user;
    }
  }

  /// this method is used to replace | with id
  String cleanUrlWith(String id) {
    return url.replaceAll("|", id);
  }
}

extension RequestMode on EndPoint {
  RequestType get requestType {
    RequestType requestType = RequestType.get;

    switch (this) {
      // case EndPoint.appConfig:
      // case EndPoint.jokesCategories:
      // case EndPoint.home:
      // case EndPoint.alert:
      case EndPoint.user:
        break;
      // case EndPoint.login:
      //   requestType = RequestType.post;
      //   break;
    }
    return requestType;
  }
}

extension Token on EndPoint {
  bool get shouldAddToken {
    var shouldAdd = true;
    switch (this) {
      // case EndPoint.appConfig:
      // case EndPoint.jokesCategories:
      // case EndPoint.alert:
      //   break;
      // case EndPoint.login:
      case EndPoint.user:
        shouldAdd = false;
        break;
      default:
    }
    return shouldAdd;
  }
}

extension FormType on EndPoint {
  FormRequestType get formType {
    FormRequestType formType = FormRequestType.raw;
    switch (this) {
      // case EndPoint.login:
      // case EndPoint.alert:
      case EndPoint.user:
        break;
      // case EndPoint.appConfig:
      // case EndPoint.jokesCategories:
      // case EndPoint.home:
      //   formType = FormRequestType.formData;
      //   break;
    }
    return formType;
  }
}
