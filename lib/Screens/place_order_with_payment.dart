
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';
import 'package:luminous_e_buy/Services/stripe.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Services/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'front_page.dart';

class OrderWithPayment extends StatefulWidget {
  OrderWithPayment({Key? key, required this.cost, required this.addressId}) : super(key: key);

  double cost;
  int addressId;

  @override
  _OrderWithPaymentState createState() => _OrderWithPaymentState();
}

class _OrderWithPaymentState extends State<OrderWithPayment> {

  late String consKey;
  late String consSecret;
  String kApiUrl = "http://10.13.3.2:80";
  dynamic formData = {};
  late Map<String, dynamic> postBody;
  String tokenId = "sk_test_51KMUcMLQfbdHsu5AqSDUZok2haPoIhnuKosmsNG7eOfYUKkZGPQhu1RSyV6PpPquIN0S3vU2RJWkBKn0DvvIsZS800ypdncc6H";
   Map<String, dynamic> customerInfo = {
     "name": "Sadly",
     "email": "sadly@gmail.com"
   };

  getPostBody() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    List<Map<String, dynamic>> products = [];
    for(int i=0; i<cartList.length; i++){
      products.add({
        "product_id": cartList[i]["id"],
        "quantity": cart[cartList[i]["id"].toString()]
      });
    }

    postBody = {
      "payment_method": "stripe_cc",
      "payment_method_title": "Credit Cards",
      "set_paid": true,
      "billing": {
        "first_name": addressList[widget.addressId]["first_name"],
        "last_name": addressList[widget.addressId]["last_name"],
        "address_1": addressList[widget.addressId]["address"],
        "city": addressList[widget.addressId]["city"],
        "country": addressList[widget.addressId]["country"],
        "phone": addressList[widget.addressId]["contact_number"],
      },
      "shipping": {
        "first_name": addressList[widget.addressId]["first_name"],
        "last_name": addressList[widget.addressId]["last_name"],
        "address_1": addressList[widget.addressId]["address"],
        "city": addressList[widget.addressId]["city"],
        "country": addressList[widget.addressId]["country"],
        "phone": addressList[widget.addressId]["contact_number"]
      },
      "line_items": products,
    };
  }

  @override
  void initState() {
    super.initState();
    getPostBody();
  }

  Future<void> sslCommerzCustomizedCall() async {
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().createOrderApi,
        consumerKey: consKey,
        consumerSecret: consSecret);

    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //   ipn_url: "www.ipnurl.com",
            multi_card_name: "visa,master,bkash",
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "ll61c2ae8fbb271",
            store_passwd: "ll61c2ae8fbb271@ssl",
            total_amount: widget.cost,
            tran_id: formData['phone'])
    );
    sslcommerz
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: 5,
            shipmentDetails: ShipmentDetails(
                shipAddress1: addressList[widget.addressId]["address"],
                shipCity: addressList[widget.addressId]["city"],
                shipCountry: addressList[widget.addressId]["country"],
                shipName: "Ship name 1",
                shipPostCode: "7860")))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "XYZ",
            customerName: addressList[widget.addressId]["first_name"],
            customerEmail: addressList[widget.addressId]["email"],
            customerAddress1: addressList[widget.addressId]["address"],
            customerCity: addressList[widget.addressId]["city"],
            customerPostCode: "200",
            customerCountry: addressList[widget.addressId]["country"],
            customerPhone: formData['phone']))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: "Water Filter",
            productCategory: "Widgets",
            general: General(
                general: "General Purpose",
                productProfile: "Product Profile"
            )
        )
    );
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      Toasts().paymentFailedToast(context);
      print("the response is: " +
          result.message.toString() +
          " code: " +
          result.code);
    } else {
      print("worked!");
      cart.clear();
      cartList.clear();
      ProductFunction().setCartMemory();
      Navigator.popUntil(context, ModalRoute.withName(''));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>FrontPage(consKey: consKey, consSecret: consSecret,),
          )
      );
      var response = await woocommerceAPI.postAsync(
        "",
        postBody,
      );
      Toasts().paymentSuccessToast(context);
      SSLCTransactionInfoModel model = result;
    }
  }

  void update() => setState(() {});
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
                hintText: 'Phone'
            ),
          ),
          TextButton(
            onPressed: () async {
              StripePay().handlePayment(customerInfo, widget.cost, widget.addressId, context);
            },
            child: const Text('pay'),
          )
        ],
      ),
    );
  }
}
