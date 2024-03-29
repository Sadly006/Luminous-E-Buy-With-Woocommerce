import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'order_redirect.dart';

class StripePay {

  getPostBody(int addressId, Map<String, dynamic> paymentDetails){
    List<Map<String, dynamic>> products = [];
    for(int i=0; i<cartList.length; i++){
      products.add({
        "product_id": cartList[i][3],
        "quantity": cart[cartList[i].toString()]
      });
    }

    Map<String, dynamic> postBody = {
      "payment_method": "stripe_cc",
      "payment_method_title": "Credit Cards",
      "set_paid": true,
      "billing": {
        "first_name": addressList[addressId]["first_name"],
        "last_name": addressList[addressId]["last_name"],
        "address_1": addressList[addressId]["address"],
        "city": addressList[addressId]["city"],
        "country": addressList[addressId]["country"],
        "phone": addressList[addressId]["contact_number"],
      },
      "shipping": {
        "first_name": addressList[addressId]["first_name"],
        "last_name": addressList[addressId]["last_name"],
        "address_1": addressList[addressId]["address"],
        "city": addressList[addressId]["city"],
        "country": addressList[addressId]["country"],
        "phone": addressList[addressId]["contact_number"]
      },
      "transaction_id": paymentDetails["id"],
      "line_items": products,
    };
    return postBody;
  }

  handlePayment(Map<String, dynamic> customerInfo, double cost, int addressId, BuildContext context) async {
    Map<String, dynamic> customer = await createUser(customerInfo);
    confirmPayment((cost*100).toInt(), customer, addressId, context);
  }

  createUser(Map<String, dynamic> customer) async {
    final response = await http.post(
        Uri.parse(API().stripeAPI+"customers"),
        headers: {
          'Authorization': 'Bearer sk_test_51KMUcMLQfbdHsu5AqSDUZok2haPoIhnuKosmsNG7eOfYUKkZGPQhu1RSyV6PpPquIN0S3vU2RJWkBKn0DvvIsZS800ypdncc6H',
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "name": customer["name"].toString(),
          "email": customer["email"].toString(),
        }
    );
    return json.decode(response.body);
  }

  // createPaymentIntent() async {
  //   final response = await http.post(
  //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //       headers: {
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body:json.encode({
  //         "userName": customer["name"],
  //         "email": customer["email"],
  //       })
  //   );
  // }

  confirmPayment(int cost, Map<String, dynamic> customer, int addressId, BuildContext context) async {
    final response = await http.post(
        Uri.parse(API().stripeAPI+"payment_intents"),
        headers: {
          'Authorization': 'Bearer '+API().stripeToken,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "amount": cost.toString(),
          "currency": "eur",
          "confirm": "true",
          "payment_method": "pm_card_visa",
          "customer": customer["id"]
        }
    );
    if(response.statusCode == 200){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String consKey = prefs.getString("consKey") as String;
      String consSecret = prefs.getString("consSecret") as String;
      WoocommerceAPI woocommerceAPI = WoocommerceAPI(
          url: API().createOrderApi,
          consumerKey: consKey,
          consumerSecret: consSecret);
      Map<String, dynamic> postBody = getPostBody(addressId, json.decode(response.body));
      var response1 = await woocommerceAPI.postAsync(
        "",
        postBody,
      );
      if(response1["data"] == null){
        OrderServices().RedirectToConfirmationPage("200", context, "");
      }
      else{
        OrderServices().RedirectToConfirmationPage("401", context, "Sorry, The Order Couldn't be Placed. Please Try Again");
      }
    }
    else{
      OrderServices().RedirectToConfirmationPage("401", context, "Sorry, The Transaction Was Not Complete. Please Try Again");
    }
  }
}