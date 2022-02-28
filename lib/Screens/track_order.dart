import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Templates/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/timeline.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder({Key? key, required this.id}) : super(key: key);
  int id;

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  bool isLoading = true;

  getImage(int index){
    if(previousOrderProductList[index]["images"].length!=0){
      return DecorationImage(
        image: NetworkImage(
            previousOrderProductList[index]["images"][0]["src"].toString()
        ),
        fit: BoxFit.cover,
      );

    }
    else{
      return const DecorationImage(
        image: AssetImage(
            "assets/no-image.png"
        ),
        fit: BoxFit.contain,
      );
    }
  }

  getColor(String status){
    if(status == "processing"){
      return Colors.green;
    }
    else if(status == "pending"){
      return Colors.grey;
    }
    else if(status == "on-hold"){
      return Colors.deepOrange;
    }
    else if(status == "completed"){
      return Colors.blueAccent;
    }
    else if(status == "cancelled"){
      return Colors.redAccent;
    }
    else if(status == "refunded"){
      return Colors.deepPurple;
    }
    else if(status == "failed"){
      return Colors.redAccent;
    }
  }

  getCircleColor(String status){
    if(status == "processing"){
      return Colors.grey;
    }
    else if(status == "pending"){
      return Colors.deepOrange;
    }
    else if(status == "on-hold"){
      return Colors.grey;
    }
    else if(status == "completed"){
      return Colors.green;
    }
    else if(status == "cancelled"){
      return Colors.redAccent;
    }
    else if(status == "refunded"){
      return Colors.deepPurple;
    }
    else if(status == "failed"){
      return Colors.redAccent;
    }
  }

  getProduct() async {
    previousOrderProductList.clear();
    final pref = await SharedPreferences.getInstance();
    String consKey = pref.getString("consKey") as String;
    String consSecret = pref.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    for(int i=0; i<orderList[widget.id]["line_items"].length; i++){
      final response = await woocommerceAPI.getAsync("/"+orderList[widget.id]["line_items"][i]["product_id"].toString());
      Map<String, dynamic> product = json.decode(response.body);
      previousOrderProductList.add(product);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getTimeLineColor(String date,){
    if(date == "null"){
      return Colors.grey;
    }
    else{
      return Colors.green;
    }
  }

  getTimeLineDate(String date){
    if(date == "null"){
      return const SizedBox(height: 0,);
    }
    else{
      date = date.substring(0, 10) + " || " + date.substring(11, 19);
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          date,
          style: TextStyle(
            color: Theme.of(context).accentColor
          ),
        ),
      );
    }
  }

  getLastStat(String stat){
    if(stat == "on-hold"){
      return "On Hold";
    }
    else if(stat == "cancelled"){
      return "Cancelled";
    }
    else if(stat == "failed"){
      return "Failed";
    }
    else if(stat == 'pending'){
      return "Pending";
    }
    else{
      return "Delivered";
    }
  }

  getLineColor(){
    List<dynamic> color = [];
    if(orderList[widget.id]["status"]=="processing"){
      color.add(Colors.grey);
    }
    else{
      color.add(getCircleColor(orderList[widget.id]["status"]));
    }
    if(orderList[widget.id]["date_modified"].toString()!="null"){
      color.add(Colors.green);
    }
    else{
      color.add(Colors.grey);
    }
    color.add(Colors.green);
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Track Your Package"),
      ),
      body: isLoading == true
        ? const Center(
          child: Loader(),
        )
        : SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Row(
                children: [
                  Text(
                    "Track Your Package",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Row(
                children: [
                  const Text(
                    "Order ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    "#"+orderList[widget.id]["id"].toString(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(3)),
              Row(
                children: [
                  const Text(
                    "Status ",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    orderList[widget.id]["status"].toString(),
                    style: TextStyle(
                        color: getColor(orderList[widget.id]["status"].toString()),
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(5)),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: previousOrderProductList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      image: getImage(index),
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(15)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      previousOrderProductList[index]["name"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).accentColor
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(2)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Quantity: " + orderList[widget.id]["line_items"][index]["quantity"].toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).accentColor
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                    );
                  }
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              // const Padding(padding: EdgeInsets.all(2)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shipping Details",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(
                      orderList[widget.id]["shipping"]["first_name"],
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(3)),
                    Text(
                      orderList[widget.id]["shipping"]["address_1"],
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(3)),
                    Text(
                      orderList[widget.id]["shipping"]["city"],
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(3)),
                    Text(
                      orderList[widget.id]["shipping"]["country"],
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              const Padding(padding: EdgeInsets.all(10)),

              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Timeline(
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getLastStat(orderList[widget.id]["status"]),
                                style: TextStyle(
                                    color: Theme.of(context).accentColor
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Processing",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Order Placed",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor
                                ),
                              ),
                              getTimeLineDate(orderList[widget.id]["date_created"].toString())
                            ],
                          ),
                        ),
                      ),
                    ],
                    indicators: <Widget>[
                      Icon(
                        Icons.circle,
                        color: getCircleColor(orderList[widget.id]["status"]),
                      ),
                      Icon(
                        Icons.circle,
                        color: getTimeLineColor(orderList[widget.id]["date_modified"].toString()),
                      ),
                      Icon(
                        Icons.circle,
                        color: getTimeLineColor(orderList[widget.id]["date_created"].toString()),
                      ),
                    ], stat: orderList[widget.id]["status"], lineColor: getLineColor(),
                  ),
                ),
              ),



              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Questions?",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Visit Help Center",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

