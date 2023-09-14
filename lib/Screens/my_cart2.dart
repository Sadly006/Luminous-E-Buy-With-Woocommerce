import 'package:flutter/material.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/product_details.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';

import 'select_address.dart';

class MyCart2 extends StatefulWidget {
  const MyCart2({Key? key}) : super(key: key);

  @override
  _MyCart2State createState() => _MyCart2State();
}

class _MyCart2State extends State<MyCart2> {
  Map<dynamic, int> cartTapped = {};
  final coupon = TextEditingController();
  int prevIndex = 0;

  _getBtnClr(List cList) {
    if (cList.isEmpty) {
      return Colors.grey;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  textShortener(String name) {
    if (name.length < 25) {
      return Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.w600,
            fontSize: 18),
      );
    } else if (name.length >= 25 && name.length < 30) {
      return Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.w600,
            fontSize: 16),
      );
    } else if (name.length > 30) {
      return Text(
        name.replaceRange(30, (name.length), "..."),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.w600,
            fontSize: 16),
      );
    }
  }

  _getWidget(Map tapped, var index, Map cart, List cartList) {
    if (tapped[cartList[index]].toString() == '1') {
      if (prevIndex != index) {
        tapped[cartList[prevIndex]] = 0;
        prevIndex = index;
      }
      return TranslationAnimatedWidget(
        duration: const Duration(milliseconds: 100),
        values: const [
          Offset(0, -5), // disabled value value
          Offset(0, 5), //intermediate value
          Offset(0, 0) //enabled value
        ],
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 6,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  cart[cartList[index].toString()] == 1
                      ? cart[cartList[index].toString()] = 1
                      : cart[cartList[index].toString()] =
                          cart[cartList[index].toString()] - 1;
                  ProductFunction().setCartMemory();
                  setState(() {});
                },
                child: SizedBox(
                  height: 45,
                  width: 40,
                  child: Center(
                    child: Text(
                      "-",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: 40,
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
                  cart[cartList[index].toString()] =
                      cart[cartList[index].toString()] + 1;
                  ProductFunction().setCartMemory();
                  setState(() {});
                },
                child: SizedBox(
                  height: 45,
                  width: 40,
                  child: Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
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
    } else if (tapped[cartList[index]].toString() == '0') {
      return const SizedBox(
        height: 53,
        width: 50,
      );
    }
  }

  getImage(int index) {
    if (cartList[index][0]["images"].length != 0) {
      return DecorationImage(
        image: NetworkImage(cartList[index][0]["images"][0]["src"].toString()),
        fit: BoxFit.cover,
      );
    } else {
      return const DecorationImage(
        image: AssetImage("assets/no-image.png"),
        fit: BoxFit.contain,
      );
    }
  }

  _getCartList() {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                        Icon(
                          Icons.delete,
                          size: 30,
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          "Remove",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    cartList.removeAt(index);
                    ProductFunction().removeFromCart(index);
                    // _removeFromCart(index);
                  });
                },
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  shadowColor: Theme.of(context).shadowColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  List<dynamic> product = cartList[index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            productList: product, index: 0)),
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: getImage(index),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 15)),
                                textShortener(
                                  cartList[index][0]['name'].toString(),
                                ),
                                const Padding(padding: EdgeInsets.all(3)),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            // width: getSBorderWidth(i)
                                          ),
                                        ),
                                        height: 20,
                                        width: 40,
                                        child: Center(
                                          child: Text(
                                            cartList[index][1],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .highlightColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 1),
                                          color: ProductFunction()
                                              .getProductColor(
                                                  cartList[index][2]),
                                        ),
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(3)),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ProductFunction().getCartPriceText(
                                      cart[cartList[index].toString()]!
                                          .toDouble(),
                                      cartList,
                                      index,
                                      context),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Padding(padding: EdgeInsets.all(2)),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 50,
                                    height: 50,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (cartTapped[cartList[index]] == 0) {
                                          cartTapped[cartList[index]] = 1;
                                          setState(() {
                                            _getWidget(cartTapped, index, cart,
                                                cartList);
                                          });
                                        } else {
                                          cartTapped[cartList[index]] = 0;
                                          setState(() {
                                            _getWidget(cartTapped, index, cart,
                                                cartList);
                                          });
                                        }
                                      },
                                      child: Card(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        elevation: 6,
                                        child: Center(
                                          child: ProductFunction()
                                              .getCartNumber(
                                                  cart[cartList[index]
                                                          .toString()]!
                                                      .toInt(),
                                                  context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: _getWidget(
                                      cartTapped, index, cart, cartList),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: cartList.length,
        ))
      ],
    );
  }

  @override
  void initState() {
    for (int i = 0; i < cartList.length; i++) {
      cartTapped[cartList[i]] = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        title: const Text(
          "My Cart",
        ),
      ),
      body: cartList.isEmpty
          ? Container(
              height: displayHeight(context) * 0.7,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(displayHeight(context), 150.0),
                ),
              ),
              child: Center(
                  child: Text(
                "You have not added anything to your cart yet",
                style: Theme.of(context).textTheme.subtitle1,
              )),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Container(
                    height: displayHeight(context) * 0.67,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.vertical(
                        bottom:
                            Radius.elliptical(displayHeight(context), 150.0),
                      ),
                    ),
                    child: _getCartList(),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.14,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                    color: Theme.of(context).highlightColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              ProductFunction()
                                  .totalCartPriceText(cartList, context),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: _getBtnClr(cartList),
                                  ),
                                  onPressed: () {
                                    if (cartList.isNotEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SelectAddress(
                                              cost: ProductFunction()
                                                  .totalCartPrice(
                                                      cartList, context),
                                            ),
                                          ));
                                    }
                                  },
                                  child: const Text("CheckOut")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
    );
  }
}
