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
    if(cartList[index]["sale_price"]==''){
      return (double.parse(cartList[index]["price"])*number);
    }
    else{
      return (double.parse(cartList[index]["sale_price"])*number);
    }
  }

  getCartPriceText(double number, List cartList, int index, BuildContext context) {
    if(cartList[index]["sale_price"]==''){
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
                "\$" + (double.parse(cartList[index]["sale_price"])*number).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                  "\$" + (double.parse(cartList[index]["price"])*number).toStringAsFixed(2),
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
    if(cartList[index]["sale_price"]==''){
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
                "\$" + (double.parse(cartList[index]["sale_price"])*number).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                  "\$" + (double.parse(cartList[index]["price"])*number).toStringAsFixed(2),
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
      total = total + getCartPrice(cart[cartList[i]["id"]]!.toDouble(), cartList, i, context);
    }
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
                "\$" + (product[index]["sale_price"]).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                  //decoration: TextDecoration.lineThrough,
                  fontSize: 18,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "\$" + (product[index]["price"]).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).accentColor,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 18,
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(3)),
          Text("Save " + product[index]["doNotApplyDiscounts"].toString() + "%", style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 16),)
        ],
      );
    }
  }

  addToCart(List product, int index, BuildContext context) async {
    int c=0;
    final pref = await SharedPreferences.getInstance();
    if(pref.getString('token') == null) {
      Toasts().cartFailedToast(context);
    }

    else if(pref.getString('token') != null) {
      for(int i=0; i<cartList.length; i++){
        if(cartList[i]['id']==product[index]['id']){
          cart[cartList[i]["id"]] = cart[cartList[i]["id"]]! + 1;
          c++;
          break;
        }
      }
      if(c==0){
        cartList.add(product[index]);
        cartIndexId.add(product[index]["id"].toString());
        cart.putIfAbsent(product[index]["id"], () => 1);
        cart[product[index]["id"]]=1;
      }
      // String encodedCartList = const JsonEncoder().convert(cartIndexId);
      // String encodedCartMap = const JsonEncoder().convert(cart);
      // pref.setString("cartList", encodedCartList);
      // pref.setString("cartMap", encodedCartMap);
      Toasts().cartSuccessToast(context);
    }
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