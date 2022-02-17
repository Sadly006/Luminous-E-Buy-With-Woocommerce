import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screens/Payment/stripe_payment.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'front_page.dart';

class OrderProcessing extends StatelessWidget {
  OrderProcessing({Key? key, required this.selectedAddress, required this.cost, required this.paymentMethod}) : super(key: key);

  int selectedAddress;
  double cost;
  String paymentMethod;
  late Map<String, dynamic> postBody;

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

  getPostBody(){
    List<Map<String, dynamic>> products = [];
    for(int i=0; i<cartList.length; i++){
      products.add({
        "product_id": cartList[i]["id"],
        "quantity": cart[cartList[i]["id"]]
      });
    }

    postBody = {
      "payment_method": "Cash On Delivery",
      "payment_method_title": "Cash On Delivery",
      "set_paid": false,
      "billing": {
        "first_name": addressList[selectedAddress]["first_name"],
        "last_name": addressList[selectedAddress]["last_name"],
        "address_1": addressList[selectedAddress]["address"],
        "city": addressList[selectedAddress]["city"],
        "country": addressList[selectedAddress]["country"],
        "phone": addressList[selectedAddress]["contact_number"],
      },
      "shipping": {
        "first_name": addressList[selectedAddress]["first_name"],
        "last_name": addressList[selectedAddress]["last_name"],
        "address_1": addressList[selectedAddress]["address"],
        "city": addressList[selectedAddress]["city"],
        "country": addressList[selectedAddress]["country"],
        "phone": addressList[selectedAddress]["contact_number"]
      },
      "line_items": products,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CheckOut",
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Icon(Icons.location_on, size: 20, color: Theme.of(context).primaryColor,)
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              addressList[selectedAddress]["first_name"],
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        Text(
                          addressList[selectedAddress]["address"]+", "+addressList[selectedAddress]["city"]+", "+addressList[selectedAddress]["country"],
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                        const Padding(padding: EdgeInsets.all(5)),
                        Text(
                          addressList[selectedAddress]["contact_number"],
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        Icon(Icons.mail, color: Theme.of(context).primaryColor,),
                        const Padding(padding: EdgeInsets.all(5)),
                        Text(
                          addressList[selectedAddress]["email"],
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Card(
                color: Colors.white70,
                child: ListView.builder(
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
                                        cartList[index]['name'].toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).accentColor
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.all(2)),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: ProductFunction().getLastPriceText(cart[cartList[index]["id"].toString()]!.toDouble(), cartList, index, context),
                                      ),
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
                                    child: ProductFunction().getCartNumber(cart[cartList[index]["id"].toString()]!.toInt(), context),
                                  ),
                                ),
                              ),
                            ],
                          )
                      );
                    }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Card(
                color: Colors.white70,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              "Subtotal: ",
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              "BDT "+cost.toString(),
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              "Shipping Fee: ",
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              "BDT 50",
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              "Total Cost: ",
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Text(
                              "BDT "+(cost+50).toString(),
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 30,
            width: displayWidth(context)*0.8,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor
                ),
                onPressed: () async {
                  if(cartList.isNotEmpty){
                    if(paymentMethod == "Online Payment"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StripePayment(cost: cost+50, addressId: selectedAddress,),
                            // builder: (context) => OrderWithPayment(cost: cost+50, addressId: selectedAddress),
                          )
                      );
                    }
                    else{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String consKey = prefs.getString("consKey") as String;
                      String consSecret = prefs.getString("consSecret") as String;
                      WoocommerceAPI woocommerceAPI = WoocommerceAPI(
                          url: API().createOrderApi,
                          consumerKey: consKey,
                          consumerSecret: consSecret);
                      getPostBody();
                      cart.clear();
                      cartList.clear();
                      Navigator.popUntil(context, ModalRoute.withName(''));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>FrontPage(consKey: consKey, consSecret: consSecret,),
                          )
                      );
                      ProductFunction().setCartMemory();
                      var response = await woocommerceAPI.postAsync(
                        "",
                        postBody,
                      );
                    }
                  }
                },
                child: const Text(
                    "Place Order"
                )
            ),
          ),
        ),
      ],
    );
  }
}
