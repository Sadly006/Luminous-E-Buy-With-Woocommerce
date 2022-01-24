import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Functions/product_functions.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';

class OrderProcessing extends StatelessWidget {
  OrderProcessing({Key? key, required this.selectedAddress, required this.cost, required this.paymentMethod}) : super(key: key);

  int selectedAddress;
  double cost;
  String paymentMethod;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CheckOut",
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              color: Colors.white70,
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
                      Padding(padding: EdgeInsets.all(5)),
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
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                      Padding(padding: EdgeInsets.all(5)),
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
                ],
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context)*0.5,
            child: Padding(
              padding: EdgeInsets.all(1),
              child: ListView.builder(
                itemCount: cartList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                                    child: ProductFunction().getLastPriceText(cart[cartList[index]["id"]]!.toDouble(), cartList, index, context),
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
                                child: ProductFunction().getCartNumber(cart[cartList[index]["id"]]!.toInt(), context),
                              ),
                            ),
                          ),
                        ],
                      )
                    );
                  }
              )
            ),
          ),
          Card(
            color: Colors.white70,
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
                    Padding(padding: EdgeInsets.all(5)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
