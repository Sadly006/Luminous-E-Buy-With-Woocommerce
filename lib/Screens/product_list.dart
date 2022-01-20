import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Functions/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/shimmer.dart';
import 'package:luminous_e_buy/Templates/product_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  AppBar appBar = AppBar(
    backgroundColor: Colors.red,
    centerTitle: true,
    title: const Text("All Products"),
  );

  static const _shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
  
  int pageIndex=1, increment = 6;
  bool _isLoading = true, fetchingMore = false;
  List<dynamic> lazyList = [];
  final _controller = ScrollController();
  late String consKey;
  late String consSecret;

  getHeight(){
    if(fetchingMore==false) {
      return displayHeight(context)-(appBar.preferredSize.height+41);
    }
    else{
      return displayHeight(context)-(appBar.preferredSize.height+70);
    }
  }

  getLength(){
    if(productList.isEmpty){
       return 50;
    }
    else{
      return productList.length;
    }
  }

  productListTemplate(List<dynamic> productList){
    double itemWidth = displayWidth(context) / 2;
    double itemHeight = 300;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: getHeight(),
            child: Shimmer(
              linearGradient: _shimmerGradient,
              child: GridView.builder(
                  controller: _controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  itemCount: getLength(),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(2),
                        child: ProductTile(productList: productList, index: index, isLoading: _isLoading,)
                    );
                  }
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: fetchingMore == true
              ? Image.asset("assets/loader.gif", fit: BoxFit.fitHeight,)
              : const Padding(padding: EdgeInsets.only(left: 1)),
          )
        ],
      ),
    );
  }

  getProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    final response = await woocommerceAPI.getAsync("?page=$pageIndex");
    print(response.statusCode);
    if(response.statusCode == 200){
      lazyList = (json.decode(response.body));
      for(int i=0; i<lazyList.length; i++){
        productList.add(lazyList[i]);
      }
      setState(() {
        _isLoading = false;
      });
      pageIndex++;
    }
  }

  fetchMore() async {
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    final response = await woocommerceAPI.getAsync("?page=$pageIndex");

    if(response.statusCode == 200){
      lazyList = (json.decode(response.body));
      for(int i=0; i<lazyList.length; i++){
        productList.add(lazyList[i]);
      }
      setState(() {
        fetchingMore = false;
      });
      pageIndex++;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double maxScroll=_controller.position.maxScrollExtent;
      double currentScroll=_controller.position.pixels;
      double delta = 0.0;
      if (maxScroll-currentScroll<=delta && fetchingMore == false) {
        setState(() {
          fetchingMore = true;
          fetchMore();
        });
      }
    });
    getProduct();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: productListTemplate(productList),
      //body: productListBody()
    );
  }
}