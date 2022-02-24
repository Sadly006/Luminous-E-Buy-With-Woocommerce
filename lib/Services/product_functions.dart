import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductFunction{
  getPriceText(List product, int index, BuildContext context) {
    if(product[index]["doNotApplyDiscounts"].toString()=='0'){
      return Text(
        "\$" + product[index]["mrp"].toString(),
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "\$" + (product[index]["mrp"] - (product[index]["price"]*product[index]["doNotApplyDiscounts"]/100)).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 5)),
              Text(
                  "\$" + (product[index]["mrp"]).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline3
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(3)),
        ],
      );
    }
  }

  getCartPrice(double number, List cartList, int index, BuildContext context) {
    if(cartList[index][0]["sale_price"]==''){
      return (double.parse(cartList[index][0]["price"])*number);
    }
    else{
      return (double.parse(cartList[index][0]["sale_price"])*number);
    }
  }

  getCartPriceText(double number, List cartList, int index, BuildContext context) {
    if(cartList[index][0]["sale_price"]==''){
      return Text(
        "\$" + getCartPrice(number, cartList, index, context).toStringAsFixed(2),
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "\$" + (double.parse(cartList[index][0]["sale_price"])*number).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                  "\$" + (double.parse(cartList[index][0]["regular_price"])*number).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline3
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(3)),
        ],
      );
    }
  }

  getLastPriceText(double number, List cartList, int index, BuildContext context) {
    if(cartList[index][0]["sale_price"]==''){
      return Text(
        "\$" + getCartPrice(number, cartList, index, context).toStringAsFixed(2),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "\$" + (double.parse(cartList[index][0]["sale_price"])*number).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                  "\$" + (double.parse(cartList[index][0]["price"])*number).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline3
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(3)),
        ],
      );
    }
  }

  totalCartPrice(List cartList, BuildContext context){
    num total=0;
    for(int i=0; i<cartList.length; i++){
      total = total + getCartPrice(cart[cartList[i].toString()]!.toDouble(), cartList, i, context);
    }
    print("Total: "+total.toString());
    return total;
  }

  totalCartPriceText(List cartList, BuildContext context){
    return Text(
      "\$"+totalCartPrice(cartList, context).toStringAsFixed(2),
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.bold
      ),
    );
  }

  getCartNumber(int number, BuildContext context) {
    return Text(
        number.toString(),
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 16,
            fontWeight: FontWeight.w800
        )
    );
  }

  detailedPriceText(List product, int index, BuildContext context) {
    if(product[index]["sale_price"].toString()==''){
      return Text(
        "\$" + product[index]["price"].toString(),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).primaryColor,
          //decoration: TextDecoration.lineThrough,
          fontSize: 18,
        ),
      );
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "\$" + (product[index]["regular_price"]).toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 18,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "\$" + (product[index]["sale_price"]).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(3)),
        ],
      );
    }
  }

  getProductColor(String color){
    if(color.toLowerCase() == 'red'){
      return Colors.redAccent;
    }
    else if(color.toLowerCase() == 'black'){
      return Colors.black;
    }
    else if(color.toLowerCase() == 'green'){
      return Colors.green;
    }
    else if(color.toLowerCase() == 'blue'){
      return Colors.blue;
    }
    else if(color.toLowerCase() == 'white'){
      return Colors.white;
    }
  }

  getSelectedSizeColor(int index, BuildContext context, int selectedSize){
    if(index == selectedSize){
      return Theme.of(context).canvasColor;
    }
    else
      return Theme.of(context).scaffoldBackgroundColor;
  }

  getSelectedColorBorderWidth(int index, int selectedColor){
    if(index == selectedColor){
      return 3.toDouble();
    }
    else
      return 1.toDouble();
  }

  setCartMemory() async {
    final pref = await SharedPreferences.getInstance();
    String encodedCartList = const JsonEncoder().convert(cartList);
    String encodedCartMap = const JsonEncoder().convert(cart);
    pref.setString("cartList", encodedCartList);
    pref.setString("cartMap", encodedCartMap);
  }

  removeFromCart(var x) {
    cartList.remove(x);
    cart.remove(x);
    setCartMemory();
  }

  // addToCart(List product, int index, BuildContext context, String size, String color) async {
  //   int c=0;
  //   final pref = await SharedPreferences.getInstance();
  //   if(pref.getString('token') == null) {
  //     Toasts().cartFailedToast(context);
  //   }
  //
  //   else if(pref.getString('token') != null) {
  //     List<dynamic> productDetails = [product[index], size, color];
  //     for(int i=0; i<cartList.length; i++){
  //       if(cartList[i]['id']==product[index]['id']){
  //         cart[cartList[i]["id"].toString()] = cart[cartList[i]["id"].toString()]! + 1;
  //         c++;
  //         break;
  //       }
  //     }
  //     if(c==0){
  //       cartList.add(product[index]);
  //       cart.putIfAbsent(product[index]["id"].toString(), () => 1);
  //       cart[product[index]["id"].toString()]=1;
  //     }
  //     setCartMemory();
  //     Toasts().cartSuccessToast(context);
  //   }
  // }

  addToCart(List product, int index, BuildContext context, String size, String color) async {
    int c=0;
    final pref = await SharedPreferences.getInstance();
    if(pref.getString('token') == null) {
      Toasts().cartFailedToast(context);
    }

    else if(pref.getString('token') != null) {
      List<dynamic> productDetails = [product[index], size, color];
      print(productDetails[1]);
      for(int i=0; i<cartList.length; i++){
        if(cartList[i].toString()==productDetails.toString()){
          print("Exists");
          cart[cartList[i].toString()] = cart[cartList[i].toString()]! + 1;
          c++;
          break;
        }
      }
      if(c==0){
        cartList.add(productDetails);
        cart.putIfAbsent(productDetails.toString(), () => 1);
        cart[productDetails.toString()]=1;
      }
      setCartMemory();
      Toasts().cartSuccessToast(context);
    }
    print("cartLength:" + cartList.length.toString());
  }

  addToWList(List product, int index, BuildContext context, Function setState) async {
    int c=0;
    final pref = await SharedPreferences.getInstance();
    if(pref.getString('token') == null) {
      Toasts().wishlistFailedToast(context);
    }
    else if(pref.getString('token') != null) {
      for(int i=0; i<wishList.length; i++){
        if(wishList[i]['id']==product[index]['id']){
          c++;
          break;
        }
      }
      if(c==0) {
        wishList.add(product[index]);
        Toasts().wishlistAddToast(context);
      }
      else if(c!=0){
        wishList.remove(product[index]);
        Toasts().wishlistRemoveToast(context);
      }
    }
    setState(() {});
  }

  getWIcon(List product, List wList, var index, BuildContext context){
    int c=0;
    for(int i=0; i<wList.length; i++){
      if(wList[i]['id']==product[index]['id']){
        c++;
        break;
      }
    }
    if(c==0) {
      return Icon(Icons.favorite_border, color: Theme.of(context).primaryColor,);
    }
    else{
      return Icon(Icons.favorite, color: Theme.of(context).primaryColor,);
    }
  }

  getWText(List product, List wList, var index){
    int c=0;
    for(int i=0; i<wList.length; i++){
      if(wList[i]['id']==product[index]['id']){
        c++;
        break;
      }
    }
    if(c==0) {
      return "Add To Wishlist";
    }

    else{
      return "Added To Wishlist";
    }
  }
}