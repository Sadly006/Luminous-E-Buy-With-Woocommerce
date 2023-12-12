import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screens/my_cart2.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screens/profile_overview.dart';
import 'package:luminous_e_buy/Screens/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentications/sign_in.dart';
import 'categories.dart';
import 'home_page.dart';

class FrontPage extends StatefulWidget {
  FrontPage({Key? key, required this.consKey, required this.consSecret})
      : super(key: key);
  final String consKey, consSecret;

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    getProduct();
    getInfo();
  }

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    info['name'] = prefs.getString("userName") as String;
    info['email'] = prefs.getString('email') as String;
  }

  getProduct() async {
    setState(() {
      isLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    if (pref.getString("cartList") != null &&
        pref.getString("cartMap") != null) {
      cartList = json.decode(pref.getString("cartList") as String);
      cart = json.decode(pref.getString("cartMap") as String);
    }
    WoocommerceAPI woocommerceAPI1 = WoocommerceAPI(
        url: API().productApi,
        consumerKey: widget.consKey,
        consumerSecret: widget.consSecret);
    final response1 = await woocommerceAPI1.getAsync("?page=1");

    WoocommerceAPI woocommerceAPI2 = WoocommerceAPI(
        url: API().productApi,
        consumerKey: widget.consKey,
        consumerSecret: widget.consSecret);
    final response2 = await woocommerceAPI2.getAsync("?page=2");

    WoocommerceAPI woocommerceAPI3 = WoocommerceAPI(
        url: API().productApi,
        consumerKey: widget.consKey,
        consumerSecret: widget.consSecret);
    final response3 = await woocommerceAPI3.getAsync("?page=3");

    if (response1.statusCode == 200 &&
        response2.statusCode == 200 &&
        response3.statusCode == 200) {
      newArrival = json.decode(response1.body);
      topPicks = json.decode(response2.body);
      forYou = json.decode(response3.body);
      setState(() {
        isLoading = false;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      Navigator.popUntil(context, ModalRoute.withName(''));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ));
    }
  }

  int index = 2;

  _getHomePageContent(int index) {
    if (index == 2) {
      return const HomePage();
    } else if (index == 1) {
      return const MyCart2();
    } else if (index == 0) {
      return const CategoryList();
    } else if (index == 3) {
      return const WishList();
    } else if (index == 4) {
      //return MapPage2(currentLocation: currentLocation, myIcon: myIcon,);
      return const ProfileOverview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == true
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset("assets/product.gif"),
                ),
              )
            : _getHomePageContent(index),
        bottomNavigationBar: ConvexAppBar(
            style: TabStyle.textIn,
            backgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).highlightColor,
            activeColor: Theme.of(context).primaryColor,
            items: const [
              TabItem(icon: (Icons.grid_view_outlined), title: 'Categories'),
              TabItem(icon: (Icons.shopping_cart_outlined), title: 'Cart'),
              TabItem(icon: (Icons.home), title: 'Home'),
              TabItem(icon: (Icons.favorite_border), title: 'Wishlist'),
              TabItem(icon: (Icons.person), title: 'Profile'),
            ],
            initialActiveIndex: 2, //optional, default as 0
            onTap: (int i) {
              setState(() {
                index = i;
                _getHomePageContent(index);
              });
            }));
  }
}
