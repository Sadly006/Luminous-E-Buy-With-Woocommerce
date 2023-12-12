import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/shimmer.dart';
import 'package:luminous_e_buy/Templates/product_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProductList extends StatefulWidget {
  CategoryProductList({Key? key, required this.categoryID, required this.categoryName}) : super(key: key);
  final String categoryID;
  final String categoryName;

  @override
  _CategoryProductListState createState() => _CategoryProductListState();
}

class _CategoryProductListState extends State<CategoryProductList> {

  getAppBar(){
    return AppBar(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      centerTitle: true,
      title: Text(widget.categoryName),
    );
  }

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
  bool _isLoading = true, fetchingMore = false, endProduct = false;
  List<dynamic> lazyList = [];
  final _controller = ScrollController();
  late String consKey;
  late String consSecret;

  getLength(){
    if(categoryProductList.isEmpty){
      return 50;
    }
    else{
      return categoryProductList.length;
    }
  }

  getWidget(){
    if(endProduct == false){
      return SizedBox(
          height: 60,
          child: Center(child: Image.asset("assets/loader.gif", fit: BoxFit.fitHeight,))
      );
    }
    else{
      return const Padding(padding: EdgeInsets.only(top: 1));
    }
  }

  productListTemplate(List<dynamic> productList){
    double itemWidth = displayWidth(context) / 2;
    double itemHeight = 300;
    return SingleChildScrollView(
      controller: _controller,
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Shimmer(
              linearGradient: _shimmerGradient,
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  itemCount: getLength(),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(5),
                        child: ProductTile(productList: categoryProductList, index: index, isLoading: _isLoading,)
                    );
                  }
              ),
            ),
          ),
          getWidget()
        ],
      ),
    );
  }

  getProduct() async {
    categoryProductList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    final response = await woocommerceAPI.getAsync("?category="+widget.categoryID);
    if(response.statusCode == 200){
      lazyList = (json.decode(response.body));
      for(int i=0; i<lazyList.length; i++){
        categoryProductList.add(lazyList[i]);
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
      if(lazyList.isEmpty){
        setState(() {
          endProduct = true;
          fetchingMore = false;
        });
      }
      else{
        setState(() {
          fetchingMore = false;
        });
      }
      pageIndex++;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double maxScroll=_controller.position.maxScrollExtent;
      double currentScroll=_controller.position.pixels;
      double delta = 50.0;
      if (maxScroll-currentScroll<=delta && fetchingMore == false && endProduct == false) {
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: productListTemplate(categoryProductList),
    );
  }
}