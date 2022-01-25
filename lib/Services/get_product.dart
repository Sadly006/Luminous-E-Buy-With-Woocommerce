import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProducts{
  getProduct(bool isLoading, Function setState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenId = prefs.getString("token");
    final response = await http.get(
        Uri.parse(API().productApi+"?page=1"),
        headers: {
          'Authorization': 'Bearer $tokenId',
        }
    );

    if(response.statusCode == 200){
      productList = json.decode(response.body);
      setState(){
        isLoading = false;
      }
    }
  }
}