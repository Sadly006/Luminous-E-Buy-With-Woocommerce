import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screens/track_order.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  bool isLoading = true;
  late String consKey, consSecret;

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    setState(() {
      isLoading = true;
    });
    WoocommerceAPI woocommerceAPI1 = WoocommerceAPI(
        url: API().createOrderApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    final response = await woocommerceAPI1.getAsync("");

    if(response.statusCode == 200){
      orderList = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                child: Image.asset("assets/product.gif"),
              ),
            )

          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  //snap: true,
                  //floating: true,
                  stretch: true,
                  expandedHeight: 160.0,
                  flexibleSpace: FlexibleSpaceBar(
                      title: Text('Order List',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      background: Image.asset(
                        "assets/orderList.png",
                        fit: BoxFit.contain,
                      )
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          tileColor: Theme.of(context).backgroundColor,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text("Order #",
                                                style: TextStyle(
                                                  color: Theme.of(context).accentColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(orderList[index]["id"].toString(),
                                                style: TextStyle(
                                                  color: Theme.of(context).accentColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                orderList[index]["date_created"].substring(0, 10) + " || " + orderList[index]["date_created"].substring(11, 18),
                                                style: TextStyle(
                                                  color: Theme.of(context).accentColor,
                                                  fontSize: 17,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Theme.of(context).primaryColor,
                                        ),
                                        child: const Text('Show More'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TrackOrder(id: index),
                                              )
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Image.asset('assets/order.png'),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],

                          ),
                        ),
                      );
                    },
                    childCount: orderList.length,
                  ),
                )
              ]
          ),
    );
  }
}
