import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../front_page.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarded", true);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FrontPage(consKey: "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee", consSecret: "cs_16950d98f2c9ddfc3112e57fa325302f8390b451",)),
    );
  }

  Widget _buildImage(String assetName, double width) {
    return Image.asset('assets/$assetName', width: width, fit: BoxFit.contain,);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0, color: Colors.black);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.black),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,

      pages: [
        PageViewModel(
          title: "Search It",
          body: "Search any product you want. We got it!",
          image: _buildImage('testing.png', displayWidth(context)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Track It",
          body: "Track your order from anywhere",
          image: _buildImage('track.jpg', displayWidth(context)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Unlimited Offers",
          body: "Get the best deals with us",
          image: _buildImage('product.gif', displayWidth(context)),
          decoration: pageDecoration,
        ),

      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: Text('Skip', style: TextStyle(color: Theme.of(context).primaryColor),),
      next: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
      done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
      curve: Curves.fastLinearToSlowEaseIn, color: Theme.of(context).primaryColor,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Theme.of(context).primaryColor,
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: Theme.of(context).primaryColor
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}