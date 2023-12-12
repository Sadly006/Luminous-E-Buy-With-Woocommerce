import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Services/stripe.dart';

import '../../Templates/loader.dart';

class StripePayment extends StatefulWidget {
  StripePayment({Key? key, required this.cost, required this.addressId})
      : super(key: key);

  final double cost;
  final int addressId;

  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Map<String, dynamic> customerInfo = {
    "name": "Taosif",
    "email": "sadly@gmail.com"
  };

  getLoader() {
    if (isLoading == true) {
      return Center(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              width: displayWidth(context),
              height: displayHeight(context),
              decoration:
                  BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
              child: const Center(child: Loader()),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              CreditCardWidget(
                glassmorphismConfig:
                    useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: Theme.of(context).primaryColor,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[
                  CustomCardTypeIcon(
                    cardType: CardType.mastercard,
                    cardImage: Image.asset(
                      'assets/mastercard.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        textColor: Theme.of(context).highlightColor,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: TextStyle(
                              color: Theme.of(context).highlightColor),
                          labelStyle: TextStyle(
                              color: Theme.of(context).highlightColor),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Theme.of(context).highlightColor),
                          labelStyle: TextStyle(
                              color: Theme.of(context).highlightColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Theme.of(context).highlightColor),
                          labelStyle: TextStyle(
                              color: Theme.of(context).highlightColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: () async {
                          isLoading = true;
                          setState(() {});
                          StripePay().handlePayment(customerInfo, widget.cost,
                              widget.addressId, context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          getLoader(),
        ],
      )),
    );
  }
}
