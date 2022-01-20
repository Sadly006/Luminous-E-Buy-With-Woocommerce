import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Functions/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screens/profile_overview.dart';
import 'package:luminous_e_buy/Screens/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Authentications/sign_in.dart';
import 'Maps/map1.dart';
import 'home_page.dart';
import 'my_cart.dart';

class FrontPage extends StatefulWidget {
  FrontPage({Key? key, required this.consKey, required this.consSecret}) : super(key: key);
  String consKey, consSecret;

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  late BitmapDescriptor myIcon;
  late LocationData _locationData;
  late StreamSubscription<LocationData> subscription;
  late Location location;
  late LocationData currentLocation;
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    location = Location();
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(500, 500)), 'assets/bicycle.png')
        .then((onValue) {
      myIcon = onValue;
    });
    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
    });
    getProduct();
  }

  getProduct() async {
    setState(() {
      isLoading = true;
    });
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

    if(response1.statusCode == 200 && response2.statusCode == 200 && response3.statusCode == 200){
      newArrival = json.decode(response1.body);
      topPicks = json.decode(response2.body);
      forYou = json.decode(response3.body);
      setState(() {
        isLoading = false;
      });
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      Navigator.popUntil(context, ModalRoute.withName(''));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>const SignIn(),
          )
      );
    }
  }


  int index = 2;

  _getHomePageContent(int index) {
    if(index == 2){
      return const HomePage();
    }
    else if(index == 1){
      return const MyCart();
    }
    else if(index == 0){
      return MapPage1(myIcon: myIcon, currentLocation: currentLocation,);
    }
    else if(index == 3){
      return const WishList();
    }
    else if(index == 4){
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
            backgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).accentColor,
            activeColor: Theme.of(context).backgroundColor,
            items: const [
              TabItem(
                  icon: (Icons.grid_view_outlined),
                  title: 'Categories'
              ),
              TabItem(
                  icon: (Icons.shopping_cart_outlined),
                  title: 'Cart'
              ),
              TabItem(
                  icon: (Icons.home),
                  title: 'Home'
              ),
              TabItem(
                  icon: (Icons.favorite_border),
                  title: 'Wishlist'
              ),
              TabItem(
                  icon: (Icons.person),
                  title: 'Profile'
              ),
            ],
            initialActiveIndex: 2,//optional, default as 0
            onTap: (int i) {
              setState(() {
                index = i;
                _getHomePageContent(index);
              });
            }
        )
    );
  }
}
