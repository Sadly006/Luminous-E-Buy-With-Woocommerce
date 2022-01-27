import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/processing_order.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethods extends StatefulWidget {
  PaymentMethods({Key? key, required this.cost, required this.selectedAddress}) : super(key: key);
  double cost;
  int selectedAddress;

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  late List<dynamic> paymentMethods;
  bool isLoading = true;

  getMethods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String consKey = prefs.getString("consKey") as String;
    String consSecret = prefs.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().paymentGatewaysApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    final response = await woocommerceAPI.getAsync("");
    print(response.statusCode);
    if(response.statusCode == 200){
      paymentMethods = (json.decode(response.body));
      print("DDDD");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMethods();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment Methods"),
          backgroundColor: Theme.of(context).primaryColor,
        ),

        body: isLoading == true
          ? Container()
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentMethods.length,
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderProcessing(selectedAddress: widget.selectedAddress, cost: widget.cost, paymentMethod: "Online Payment")
                                )
                            );
                          },
                          child: SizedBox(
                            width: displayWidth(context),
                            child: Row(
                              children: [
                                const Padding(padding: EdgeInsets.all(5)),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image.network("https://avatars.githubusercontent.com/u/19384040?s=200&v=4", fit: BoxFit.cover,),
                                ),
                                const Padding(padding: EdgeInsets.all(10)),
                                Text(
                                  paymentMethods[index]["title"],
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                      ],
                    );
                  }
              ),

          )

        //
        //
        // body: Column(
        //   children: [
        //     const Padding(padding: EdgeInsets.all(5)),
        //     Container(
        //       height: 0.5,
        //       color: Colors.grey,
        //     ),
        //     const Padding(padding: EdgeInsets.all(5)),
        //     GestureDetector(
        //       onTap: (){
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => OrderProcessing(selectedAddress: selectedAddress, cost: cost, paymentMethod: "Online Payment")
        //             )
        //         );
        //       },
        //       child: SizedBox(
        //         width: displayWidth(context),
        //         child: Row(
        //           children: [
        //             const Padding(padding: EdgeInsets.all(5)),
        //             SizedBox(
        //               height: 40,
        //               width: 40,
        //               child: Image.network("https://avatars.githubusercontent.com/u/19384040?s=200&v=4", fit: BoxFit.cover,),
        //             ),
        //             const Padding(padding: EdgeInsets.all(10)),
        //             Text(
        //               "Pay Now",
        //               style: TextStyle(
        //                   color: Theme.of(context).accentColor
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     const Padding(padding: EdgeInsets.all(5)),
        //     Container(
        //       height: 0.5,
        //       color: Colors.grey,
        //     ),
        //     const Padding(padding: EdgeInsets.all(5)),
        //     GestureDetector(
        //       onTap: (){
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => OrderProcessing(selectedAddress: selectedAddress, cost: cost, paymentMethod: "Cash On Delivery")
        //             )
        //         );
        //       },
        //       child: SizedBox(
        //         width: displayWidth(context),
        //         child: Row(
        //           children: [
        //             const Padding(padding: EdgeInsets.all(5)),
        //             SizedBox(
        //               height: 40,
        //               width: 40,
        //               child: Image.network("https://cdn.iconscout.com/icon/premium/png-64-thumb/cash-on-delivery-2213933-1855306.png", fit: BoxFit.cover,),
        //             ),
        //             const Padding(padding: EdgeInsets.all(10)),
        //             Text(
        //               "Cash On Delivery",
        //               style: TextStyle(
        //                   color: Theme.of(context).accentColor
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     const Padding(padding: EdgeInsets.all(5)),
        //
        //     Container(
        //       height: 0.5,
        //       color: Colors.grey,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}


