import "dart:collection";
import 'dart:convert';
import 'dart:io';
import "dart:math";
import "dart:core";
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

class WoocommerceAPI {
  String url;
  String consumerKey;
  String consumerSecret;
  bool? isHttps;

  WoocommerceAPI({
    required this.url,
    required this.consumerKey,
    required this.consumerSecret,
  }) {
    url = url;
    consumerKey = consumerKey;
    consumerSecret = consumerSecret;

    if (url.startsWith("https")) {
      isHttps = true;
    } else {
      isHttps = false;
    }
  }

  String _getOAuthURL(String requestMethod, String queryUrl) {

    String token = "";
    String url = queryUrl;
    bool containsQueryParams = url.contains("?");

    Random rand = Random();
    List<int> codeUnits = List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    String nonce = String.fromCharCodes(codeUnits);

    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    String method = requestMethod;
    String baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    String signingKey = consumerSecret + "&" + token;
    crypto.Hmac hmacSha1 =
    crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1

    crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));

    String finalSignature = base64Encode(signature.bytes);

    String requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }
    return requestUrl;
  }

  Exception _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
      case 401:
      case 404:
      case 500:
        throw Exception(
            WooCommerceError.fromJson(json.decode(response.body)).toString());
      default:
        throw Exception(
            "An error occurred, status code: ${response.statusCode}");
    }
  }

  Future<dynamic> getAsync(String endPoint) async {
    String queryUrl = url+endPoint;
    final response = await http.get(Uri.parse(_getOAuthURL("GET", queryUrl)));
    return response;
  }

  postAsync(String endPoint, Map data) async {
    String queryUrl = url+endPoint;

    http.Client client = http.Client();
    http.Request request = http.Request('POST', Uri.parse(_getOAuthURL("POST", queryUrl)));
    request.headers[HttpHeaders.contentTypeHeader] =
    'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    String response =
    await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    return dataResponse;
  }
}


class QueryString {
  static Map parse(String query) {
    RegExp search = RegExp('([^&=]+)=?([^&]*)');
    Map result = {};

    if (query.startsWith('?')) query = query.substring(1);

    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1) ?? "")] = decode(match.group(2) ?? "");
    }

    return result;
  }
}

class WooCommerceError {
  String? _code;
  String? _message;
  Data? _data;

  WooCommerceError({String? code, String? message, Data? data}) {
    _code = code;
    _message = message;
    _data = data;
  }

  WooCommerceError.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  @override
  String toString() {
    return "WooCommerce Error!\ncode: $_code\nmessage: $_message\nstatus: ${_data?.status}";
  }
}

class Data {
  int? _status;

  Data({required int status}) {
    _status = status;
  }

  int? get status => _status;

  Data.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
  }
}

