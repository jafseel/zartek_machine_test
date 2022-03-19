import 'dart:io';
import 'dart:convert';

import 'package:zartek_machine_test/model/restaurant.dart';

import '/notifiers/loader_notifier.dart' show LoadingNotifer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() {
    return _instance;
  }

  final String API_URL = 'https://www.mocky.io/v2/';

  BuildContext? context;

  Future<T?> execute<T, K>(String url,
      {Map? params,
      bool isGet = false,
      bool showSuccessAlert = false,
      bool isShowToast = true,
      LoadingNotifer? loadingNotifer,
      http.MultipartRequest? multipartRequest,
      bool isThrowExc = false}) async {
    if (await checkInternet() == false) {
      print('checkInternet no internet');
      if (isThrowExc) {
        return Future.error("No Internet Connetction");
      }
      showToast("No Internet Connetction", isShowToast: isShowToast);
      return null;
    }
    loadingNotifer?.isLoading = true;
    if (!url.startsWith("http")) {
      url = "$API_URL$url";
    }
    params ??= {};

    params.removeWhere((key, value) => value == null);

    final header = <String, String>{};

    Uri uri = Uri.parse(url);

    debugPrint("api url: $url \n params: $params");
    http.Response resp = await (isGet
        ? http.get(uri, headers: header)
        : http.post(uri, body: params, headers: header));

    String response = resp.body.trim().isNotEmpty ? resp.body : "{}";
    printWrapped(response);

    var responseJson;
    try {
      responseJson = json.decode(response);
    } catch (e) {}

    if (responseJson == null) {
      loadingNotifer?.isLoading = false;
      if (isThrowExc) {
        return Future.error("Something went wrong!");
      }
      showToast("Something went wrong!", isShowToast: isShowToast);
      return null;
    }

    loadingNotifer?.isLoading = false;

    return fromJsonToModel<T, K>(responseJson);
  }

  void _printMultipartParameters(http.MultipartRequest multipartRequest) {
    debugPrint("mulipart url: ${multipartRequest.url.toString()} \n params: " +
        multipartRequest.fields.toString());
    multipartRequest.files.forEach((element) {
      debugPrint(
          "params mulipart file: ${element.field} : ${element.filename} contentType: ${element.contentType}");
    });
  }

  void printWrapped(String text) {
    debugPrint('Response: ');
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  T fromJsonToModel<T, K>(dynamic json) {
    if (json is Iterable) {
      return _fronJsonToList<K>(json as List?) as T;
      // } else
    } else {
      json as Map<String, dynamic>;
      if (T == RestaurantResponse) {
        return RestaurantResponse.fromJson(json) as T;
        // } else if (T == CommonResponse) {
        //   return CommonResponse.fromJson(json) as T;
      } else {
        debugPrint('MJM Api response model not added');
        return json as T;
      }
    }

    // }
  }

  Future<bool> checkInternet() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      // print('not connected');
      isConnected = false;
    }
    return isConnected;
  }

  void showToast(String? message, {bool isShowToast = true}) {
    if (context == null ||
        message == null ||
        message.trim().isEmpty ||
        message.trim().toLowerCase() == 'success' ||
        !isShowToast) {
      return;
    }

    // ScaffoldMessenger?.of(context!)
    //     .showSnackBar(SnackBar(content: Text(message)));
  }

  void showAlert(String? message) {
    if (context == null || message == null || message.trim().isEmpty) {
      return;
    }
    try {
      showDialog(
        context: context!,
        builder: (context) => AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'))
          ],
        ),
      );
    } catch (e) {}
  }

  List<K> _fronJsonToList<K>(List? jsonList) {
    List<K> output =
        jsonList?.map((e) => fromJsonToModel<K, Null>(e)).toList() ??
            List.empty();

    return output;
  }
}
