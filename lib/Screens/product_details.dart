import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screens/my_cart.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';
import 'package:luminous_e_buy/Services/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Templates/product_tile.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant_Values/lists.dart';
import '../Constant_Values/lists.dart';
import 'Shop/shop_product_list.dart';
import 'image_view.dart';

class ProductDetails extends StatefulWidget {
  List<dynamic> productList2 = [];
  int index = 0;
  ProductDetails({Key? key, required this.productList2, required this.index}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  late String consKey;
  late String consSecret;
  bool isLoading = true;
  int selectedSize = 0;
  int selectedColor = 0;

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

  getLength(){
    if(relatedProductList.isEmpty){
      return 50;
    }
    else{
      return relatedProductList.length;
    }
  }

  getHeight(){
    if(relatedProductList.isEmpty){
      return 300*50 as double?;
    }
    else{
      return 300*relatedProductList.length/2;
    }
  }

  productListTemplate(int i){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProductTile(productList: relatedProductList, index: i, isLoading: isLoading),
        ProductTile(productList: relatedProductList, index: i+1, isLoading: isLoading),
      ],
    );

  }

  productListing(){
    // if(relatedProductList.length%2==0){
    //   for(int i=0; i<(relatedProductList.length+1); ){
    //     productListTemplate(i);
    //     i+=2;
    //   }
    // }
    // else{
    //   for(int i=0; i<(relatedProductList.length-1); ){
    //     productListTemplate(i);
    //     i+=2;
    // }
    int j = relatedProductList.length-2;
    return ProductTile(productList: relatedProductList, index: j, isLoading: isLoading);
  }

  getSimilarProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    print(widget.productList2[widget.index]["related_ids"].length);
    for(int i=0; i<widget.productList2[widget.index]["related_ids"].length; i++){
      final response = await woocommerceAPI.getAsync("/"+(widget.productList2[widget.index]["related_ids"][i].toString()));
      if(response.statusCode==200){
        relatedProductList.add(response.body);
      }
      print(widget.productList2[widget.index]["related_ids"][i]);
    }
    setState(() {
      isLoading = false;
    });
    print(relatedProductList.length);
  }

  _getContainer(List product, int index){
    if(product[index]["sale_price"].toString()==''){
      return const Padding(padding: EdgeInsets.all(0));
    }
    else{
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          height: 15,
          width: 35,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), topRight: Radius.circular(5)),
          ),
          child: const Center(
              child: Text(
                  "Sale",
                style: TextStyle(
                  fontSize: 12
                ),
              )
          ),
        ),
      );
    }
  }

  getStock(String stock){
    if(stock=="instock"){
      return Container(
        width: 70,
        height: 17,
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Center(
          child: Text(
              "In Stock",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white
          ),
          ),
        ),
      );
    }
    else{
      return Container(
        width: 85,
        height: 17,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Center(
          child: Text(
            "Out Of Stock",
            style: TextStyle(
                fontSize: 12,
                color: Colors.white
            ),
          ),
        ),
      );
    }
  }

  getImage(){
    if(widget.productList2[widget.index]["images"].length!=0){
      return PhotoViewGallery.builder(
        itemCount: widget.productList2[widget.index]["images"].length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              widget.productList2[widget.index]["images"][index]['src'],
            ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        enableRotation: true,
      );
    }
    else{
      return Image.asset(
        "assets/no-image.png",
        fit: BoxFit.contain,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSimilarProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          centerTitle: true,
          title: Text(
            widget.productList2[widget.index]["name"].toString(),
            style: const TextStyle(
              fontSize: 18
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(delegate: SliverChildBuilderDelegate(
                  (BuildContext context, index) {
                  return Column(
                    children: [
                      OpenContainer(
                        transitionType: ContainerTransitionType.fadeThrough,
                        closedBuilder: (BuildContext _, VoidCallback openContainer) {
                          return Container(
                            height: displayHeight(context)*0.45,
                            width: displayWidth(context)*1,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: getImage(),
                          );
                        },
                        openBuilder: (BuildContext _, VoidCallback closeContainer) {
                          return ImageView(productList: widget.productList2, index: widget.index);
                        },
                        onClosed: (_) =>{},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: SizedBox(
                            width: displayWidth(context) * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _getContainer(widget.productList2, widget.index),
                                  SizedBox(
                                    width: displayWidth(context)*0.8,
                                    child: Text(
                                      widget.productList2[widget.index]["name"].toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(2)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ProductFunction().detailedPriceText(widget.productList2, widget.index, context),
                                      getStock(widget.productList2[widget.index]["stock_status"]),
                                    ],
                                  )
                                  // Text(
                                  //   "\$" + (widget.productList2[widget.index]["price"]).toString(),
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Theme.of(context).primaryColor,
                                  //     //decoration: TextDecoration.lineThrough,
                                  //     fontSize: 18,
                                  //   ),
                                  // )
                                  ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(2),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => ShopProductList(shopId: widget.productList2[widget.index]["shopId"]-1,),
                      //           )
                      //       );
                      //     },
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey[500],
                      //           borderRadius: const BorderRadius.all(Radius.circular(8))
                      //       ),
                      //       height: 75,
                      //       width: displayWidth(context)*0.85,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.all(10),
                      //             child: Container(
                      //                 decoration: const BoxDecoration(
                      //                     color: Colors.white54,
                      //                     borderRadius: BorderRadius.all(Radius.circular(8))
                      //                 ),
                      //                 child: const Icon(Icons.chevron_right)
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                "Available Sizes",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                for(int i=0; i<productSizeList.length; i++)
                                  GestureDetector(
                                    onTap: (){
                                      selectedSize = i;
                                      setState(() {});
                                      },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                            // width: getSBorderWidth(i)
                                          ),
                                          color: ProductFunction().getSelectedSizeColor(i, context, selectedSize),
                                        ),
                                        height: 20,
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            productSizeList[i],
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                "Available Colors",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                for(int i=0; i<productColorList.length; i++)
                                  GestureDetector(
                                    onTap: (){
                                      selectedColor = i;
                                      setState(() {});
                                      },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                            width: ProductFunction().getSelectedColorBorderWidth(i, selectedColor)
                                          ),
                                          color: ProductFunction().getProductColor(productColorList[i].toString()),
                                        ),
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        )
                      ),

                      // const Padding(padding: EdgeInsets.all(1.5)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SizedBox(
                          height: 300,
                          child: DefaultTabController(
                            length: 3,
                            child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: const Size.fromHeight(50),
                                child: AppBar(
                                  elevation: 0,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  automaticallyImplyLeading: false,
                                  title: TabBar(
                                      indicatorColor: Theme.of(context).primaryColor,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      tabs: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text("Description", style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: displayWidth(context)*0.035,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text("Specification", style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: displayWidth(context)*0.035,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text("Additional Info", style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: displayWidth(context)*0.034,
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              body: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      widget.productList2[widget.index]["short_description"].toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Text(
                                      widget.productList2[widget.index]["description"].toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                        color: Theme.of(context).accentColor,

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                      style: TextStyle(
                                          fontSize: 13,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                      //productListing(),
                    ],
                  );
                },
                childCount: 1
            ))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).backgroundColor,
          type: BottomNavigationBarType.fixed,
          elevation: 20,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.5, color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      ProductFunction().addToWList(widget.productList2, widget.index, context, setState);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProductFunction().getWIcon(widget.productList2, wishList, widget.index, context),
                          Text(ProductFunction().getWText(widget.productList2, wishList, widget.index).toString(),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      ProductFunction().addToCart(widget.productList2, widget.index, context, productSizeList[selectedSize], productColorList[selectedColor]);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MyCart(),
                      //     )
                      // );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_cart_outlined, color: Colors.white,),
                          Text("Add To Cart",
                            style: TextStyle(
                                color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
