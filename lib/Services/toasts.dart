import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Toasts{
  cartSuccessToast(BuildContext context){
    showToast('Added to cart!',
      context: context,
      backgroundColor: const Color.fromRGBO(135, 206, 250, 1),
      textStyle: const TextStyle(color: Colors.black),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  cartFailedToast(BuildContext context){
    showToast('SignIn to add to cart!',
      context: context,
      backgroundColor: const Color.fromRGBO(255, 182, 193, 1),
      textStyle: const TextStyle(color: Colors.black),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
  paymentSuccessToast(BuildContext context){
    showToast('Payment Successful!',
      context: context,
      backgroundColor: const Color.fromRGBO(135, 206, 250, 1),
      textStyle: const TextStyle(color: Colors.black),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
  paymentFailedToast(BuildContext context){
    showToast('Payment Failed!',
      context: context,
      backgroundColor: const Color.fromRGBO(255, 182, 193, 1),
      textStyle: const TextStyle(color: Colors.black),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
  wishlistAddToast(BuildContext context){
    showToast('Added to WishList!',
      context: context,
      textStyle: const TextStyle(color: Colors.black),
      backgroundColor: const Color.fromRGBO(135, 206, 250, 1),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
  wishlistRemoveToast(BuildContext context){
    showToast('Removed From WishList!',
      context: context,
      backgroundColor: const Color.fromRGBO(255, 182, 193, 1),
      textStyle: const TextStyle(color: Colors.black),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
  wishlistFailedToast(BuildContext context){
    showToast('SignIn To Add To WishList!',
      context: context,
      backgroundColor: const Color.fromRGBO(255, 182, 193, 1),
      textStyle: const TextStyle(color: Colors.black),
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}