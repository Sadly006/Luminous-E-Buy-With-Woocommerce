import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder({Key? key, required this.id}) : super(key: key);
  int id;

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  bool isLoading = true;

  getImage(int index){
    if(cartList[index]["images"].length!=0){
      return DecorationImage(
        image: NetworkImage(
            cartList[index]["images"][0]["src"].toString()
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

  getProduct() async {
    previousOrderProductList.clear();
    final pref = await SharedPreferences.getInstance();
    String consKey = pref.getString("consKey") as String;
    String consSecret = pref.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    for(int i=0; i<orderList[widget.id]["line_items"].length(); i++){
      final response = await woocommerceAPI.getAsync("/"+orderList[widget.id]["line_items"][i]["id"].toString());
      previousOrderProductList.add(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Your Package"),
      ),
      body: isLoading == true
        ? Container()
        : SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  const Text(
                    "Order ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "#"+orderList[widget.id]["id"],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cartList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
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
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      previousOrderProductList[index]['name'].toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).accentColor
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(2)),

                                  ],
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                width: 45,
                                height: 45,
                                child: Center(
                                  child: ProductFunction().getCartNumber(cart[cartList[index]["id"]]!.toInt(), context),
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

