import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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

  String kApiUrl = "https://api.stripe.com/v1/";
  dynamic formData = {};
  late Map<String, dynamic> postBody;
  CardDetails _card = CardDetails();
  bool? _saveCard = false;
  String tokenId = "sk_test_51KMUcMLQfbdHsu5AqSDUZok2haPoIhnuKosmsNG7eOfYUKkZGPQhu1RSyV6PpPquIN0S3vU2RJWkBKn0DvvIsZS800ypdncc6H";

  getPostBody(){
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

  Future<void> _handlePayPress() async {
    await Stripe.instance.dangerouslyUpdateCardDetails(_card);

    try {
      // 1. Gather customer billing information (ex. email)

      const billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(const PaymentMethodParams.card(
        billingDetails: billingDetails,
      ));

      // 3. call API to create PaymentIntent
      final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd', // mocked data
        items: [
          {'id': 'id'}
        ],
      );

      if (paymentIntentResult['error'] != null) {
        // Error during creating or confirming Intent
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        // Payment succedeed

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
            Text('Success!: The payment was confirmed successfully!')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        // 4. if payment requires action calling handleCardAction
        final paymentIntent = await Stripe.instance
            .handleCardAction(paymentIntentResult['clientSecret']);

        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          // 5. Call API to confirm intent
          await confirmIntent(paymentIntent.id);
        } else {
          // Payment succedeed
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: ${paymentIntentResult['error']}')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId);
    if (result['error'] != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Success!: The payment was confirmed successfully!')));
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse('$kApiUrl/charge-card-off-session');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      },
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<Map<String, dynamic>>? items,
  }) async {
    final url = Uri.parse('$kApiUrl/pay-without-webhooks');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items
      }),
    );
    return json.decode(response.body);
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                    'If you don\'t want to or can\'t rely on the CardField you'
                        ' can use the dangerouslyUpdateCardDetails in combination with '
                        'your own card field implementation. \n\n'
                        'Please beware that this will potentially break PCI compliance: '
                        'https://stripe.com/docs/security/guide#validating-pci-compliance')),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Number'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(number: number);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Exp. Year'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(
                              expirationYear: int.tryParse(number));
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Exp. Month'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(
                              expirationMonth: int.tryParse(number));
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'CVC'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(cvc: number);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              value: _saveCard,
              onChanged: (value) {
                setState(() {
                  _saveCard = value;
                });
              },
              title: Text('Save card during payment'),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () { _handlePayPress(); },
                child: const Text("Pay now"),

                // onPressed: () async {
                //   // if (_key.currentState != null) {
                //   //   _key.currentState?.save();
                //   //   //sslCommerzGeneralCall();
                //   //   sslCommerzCustomizedCall();
                //   // }
                //   final paymentMethod = await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());
                //   print(paymentMethod);
                // },
              )
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('SSLCommerz'),
  //     ),
  //     body: Form(
  //       key: _key,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               CardField(
  //                 onCardChanged: (card: card) {
  //                   print(card);
  //                 },
  //               ),
  //               // Padding(
  //               //   padding: const EdgeInsets.all(8.0),
  //               //   child: CreditCardWidget(
  //               //     glassmorphismConfig:
  //               //     useGlassMorphism ? Glassmorphism.defaultConfig() : null,
  //               //     cardNumber: cardNumber,
  //               //     expiryDate: expiryDate,
  //               //     cardHolderName: cardHolderName,
  //               //     cvvCode: cvvCode,
  //               //     showBackView: isCvvFocused,
  //               //     obscureCardNumber: true,
  //               //     obscureCardCvv: true,
  //               //     isHolderNameVisible: true,
  //               //     cardBgColor: Colors.red,
  //               //     backgroundImage:
  //               //     useBackgroundImage ? 'assets/card_bg.png' : null,
  //               //     isSwipeGestureEnabled: true,
  //               //     onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
  //               //     customCardTypeIcons: <CustomCardTypeIcon>[
  //               //       CustomCardTypeIcon(
  //               //         cardType: CardType.mastercard,
  //               //         cardImage: Image.asset(
  //               //           'assets/mastercard.png',
  //               //           height: 48,
  //               //           width: 48,
  //               //         ),
  //               //       ),
  //               //     ],
  //               //   ),
  //               // ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     const Text("Amount",
  //                       style: TextStyle(
  //                         color: Colors.black
  //                       ),
  //                     ),
  //                     Text(widget.cost.toString(),
  //                       style: const TextStyle(
  //                           color: Colors.black
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   primary: Theme.of(context).primaryColor,
  //                 ),
  //                 onPressed: () { _handlePayPress(card); },
  //                 child: const Text("Pay now"),
  //
  //                 // onPressed: () async {
  //                 //   // if (_key.currentState != null) {
  //                 //   //   _key.currentState?.save();
  //                 //   //   //sslCommerzGeneralCall();
  //                 //   //   sslCommerzCustomizedCall();
  //                 //   // }
  //                 //   final paymentMethod = await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());
  //                 //   print(paymentMethod);
  //                 // },
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
