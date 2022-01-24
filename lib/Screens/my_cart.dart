import 'package:flutter/material.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Functions/product_functions.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/product_details.dart';

import 'select_address.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {

  Map<dynamic, int> cartTapped = {};

  _removeFromCart(var x){
    cartList.remove(x);
    cart.remove(x);
  }
  _getBtnClr(List cList){
    if(cList.isEmpty){
      return Colors.grey;
    }
    else{
      return Theme.of(context).primaryColor;
    }
  }

  textShortener(String name) {

    if(name.length<25){
      return Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w600,
            fontSize: 18
        ),
      );
    }
    else if(name.length>=25 && name.length<30){
      return Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w600,
            fontSize: 16
        ),
      );
    }
    else if(name.length>30){
      return Text(
        name.replaceRange(30, (name.length), "..."),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w600,
            fontSize: 16
        ),
      );
    }
  }

  _getWidget(Map tapped, var index, Map cart, List cartList){
    if(tapped[cartList[index]].toString() == '1'){
      return TranslationAnimatedWidget(
        duration: const Duration(milliseconds: 100),
        values: const [
          Offset(5, 0), // disabled value value
          Offset(-5, 0), //intermediate value
          Offset(0, 0) //enabled value
        ],
        child: Card(
          elevation: 6,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  cart[cartList[index]["id"]] == 1
                      ? cart[cartList[index]["id"]] = 1
                      : cart[cartList[index]["id"]] = cart[cartList[index]["id"]]-1;
                  setState(() {
                    // ProductFunction().getCartNumber(cart[cartList[index]]!.toInt(), context);
                    // ProductFunction().getCartPriceText(cart[cartList[index]]!.toDouble(), cartList, index, context);
                    //_getPrice(cart[cartList[index]]!.toDouble(), cartList[index]['price'].toDouble());
                  });
                },
                child: SizedBox(
                  height: 35,
                  width: 30,
                  child: Center(
                    child: Text(
                      "-",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 2,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  cart[cartList[index]["id"]] = cart[cartList[index]["id"]]+1;
                  setState(() {
                    // ProductFunction().getCartNumber(cart[cartList[index]]!.toInt(), context);
                  });
                },
                child: SizedBox(
                  height: 35,
                  width: 30,
                  child: Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else if(tapped[cartList[index]].toString() == '0'){
      return const SizedBox(
        height: 40,
        width: 50,
      );
    }
  }

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

  _getCartList() {
    return CustomScrollView(
      slivers: [
        SliverList(delegate: SliverChildBuilderDelegate(
              (BuildContext context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Dismissible(
                direction: DismissDirection.startToEnd,
                key: ValueKey<dynamic>(cartList[index]),
                background: Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                  child: Center(
                    child: Row(
                      children: const [
                        Padding(padding: EdgeInsets.all(2)),
                        Icon(Icons.delete, size: 30,),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          "Remove",
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    cartList.removeAt(index);
                    _removeFromCart(index);
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetails(productList2: cartList, index: index)),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                          child: Container(
                            width: 80,
                            height: 80,
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
                            const Padding(padding: EdgeInsets.only(top: 15)),
                            textShortener(cartList[index]['name'].toString(),),
                            const Padding(padding: EdgeInsets.all(2)),
                            const Text(
                              "Size: L || Color: Black",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ProductFunction().getCartPriceText(cart[cartList[index]["id"]]!.toDouble(), cartList, index, context),
                              //child: ProductFunction().getCartPriceText(cart[cartList[index]]!.toDouble(), cartList, index, context),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: displayWidth(context)*0.4,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Padding(padding: EdgeInsets.all(2)),
                                        Container(
                                          child: _getWidget(cartTapped, index, cart, cartList),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: GestureDetector(
                                              onTap: () {
                                                if(cartTapped[cartList[index]] == 0) {
                                                  cartTapped[cartList[index]] = 1;
                                                  setState(() {
                                                    _getWidget(cartTapped, index, cart, cartList);
                                                  });
                                                }
                                                else{
                                                  cartTapped[cartList[index]] = 0;
                                                  setState(() {
                                                    _getWidget(cartTapped, index, cart, cartList);
                                                  });
                                                }
                                              },
                                              child: Card(
                                                elevation: 6,
                                                child: Center(
                                                  child: ProductFunction().getCartNumber(cart[cartList[index]["id"]]!.toInt(), context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: cartList.length,
        )
        )
      ],
    );
  }

  @override
  void initState() {
    for(int i=0; i<cartList.length; i++){
      cartTapped[cartList[i]] = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: MediaQuery.of(context).size.height/8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(displayHeight(context), 150.0),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "My Cart",
        ),
      ),
      body: cartList.isEmpty
          ? SizedBox(
              height: displayHeight(context)*1,
              child: Center(child: Text("You have not added anything to your cart yet",
                style: Theme.of(context).textTheme.subtitle1,
              )),
            )
          : Container(
              child: _getCartList(),
            ),

      persistentFooterButtons: <Widget>[
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                ProductFunction().totalCartPriceText(cartList, context),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: _getBtnClr(cartList),
                  ),
                  onPressed: () {
                    if(cartList.isNotEmpty){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectAddress(cost: ProductFunction().totalCartPrice(cartList, context),),
                        )
                      );
                    }
                  },
                  child: const Text(
                      "CheckOut"
                  )
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}