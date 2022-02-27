import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Screens/Confirmations/error.dart';
import 'package:luminous_e_buy/Screens/Confirmations/success.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';

import '../Constant_Values/lists.dart';

class OrderServices{
  RedirectToConfirmationPage(String statCode, BuildContext context, String errorMessage){
    if(statCode == "200"){
      cart.clear();
      cartList.clear();
      ProductFunction().setCartMemory();
      Navigator.popUntil(context, ModalRoute.withName(''));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>const SuccessScreen(),
          )
      );
    }
    else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>ErrorScreen(errorMessage: errorMessage),
          )
      );
    }
  }
}