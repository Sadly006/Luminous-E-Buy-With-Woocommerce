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

  final _key = GlobalKey<FormState>();
  dynamic formData = {};
  late Map<String, dynamic> postBody;

  getPostBody(){
    List<Map<String, dynamic>> products = [];
    for(int i=0; i<cartList.length; i++){
      products.add({
        "product_id": cartList[i]["id"],
        "quantity": cart[cartList[i]["id"]]
      });
    }

    postBody = {
      "payment_method": "bKash",
      "payment_method_title": "Online Payment",
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String consKey = prefs.getString("consKey") as String;
    String consSecret = prefs.getString("consSecret") as String;
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
            builder: (context) =>FrontPage(consKey: "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee", consSecret: "cs_16950d98f2c9ddfc3112e57fa325302f8390b451",),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSLCommerz'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      hintText: "Phone number",
                    ),
                    onSaved: (value) {
                      formData['phone'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Amount",
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                      Text(widget.cost.toString(),
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ],
                  )
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: const Text("Pay now"),
                  onPressed: () {
                    if (_key.currentState != null) {
                      _key.currentState?.save();
                      //sslCommerzGeneralCall();
                      sslCommerzCustomizedCall();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
