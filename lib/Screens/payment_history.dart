import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {

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
    final response = await http.get(
        Uri.parse(API().stripeAPI+"search?query=is%3Apayment_intents%20sadly@gmail.com&prefix=false"),
        headers: {
          'Authorization': 'Bearer '+API().stripeToken,
          "Content-Type": "application/x-www-form-urlencoded",
        },
    );

    if(response.statusCode == 200){
      paymentHistory = json.decode(response.body);

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
                  title: Text('Payment History',
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
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
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(paymentHistory['data'][index]['id'],
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: smallTextSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const Padding(padding: EdgeInsets.all(2)),

                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          "\$"+(paymentHistory['data'][index]["amount"]/100).toString(),
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: smallTextSize,
                                          ),
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.all(2)),

                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                            DateFormat('dd/MM/yyyy, HH:mm:ss').format(DateTime.fromMicrosecondsSinceEpoch(paymentHistory['data'][index]['charges']['data'][0]['created']*1000000)).toString(),
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: extraSmallTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Image.network("https://brandslogos.com/wp-content/uploads/thumbs/stripe-logo-2.png"),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],

                          ),
                        ),

                      ],
                    ),
                  );
                },
                childCount: paymentHistory["data"].length,
              ),
            )
          ]
      ),
    );
  }
}
