import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screens/my_cart.dart';
import 'package:luminous_e_buy/Services/product_functions.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Templates/product_tile.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'image_view.dart';

class ProductDetails extends StatefulWidget {
  List<dynamic> productList = [];
  int index = 0;
  ProductDetails({Key? key, required this.productList, required this.index})
      : super(key: key);

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

  getLength() {
    if (relatedProductList.isEmpty) {
      return 50;
    } else {
      return relatedProductList.length;
    }
  }

  getHeight() {
    if (relatedProductList.isEmpty) {
      return 300 * 50 as double?;
    } else {
      return 300 * relatedProductList.length / 2;
    }
  }

  productListTemplate(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProductTile(
            productList: relatedProductList, index: i, isLoading: isLoading),
        ProductTile(
            productList: relatedProductList,
            index: i + 1,
            isLoading: isLoading),
      ],
    );
  }

  _getContainer(List product, int index) {
    if (product[index]["sale_price"].toString() == '') {
      return const Padding(padding: EdgeInsets.all(0));
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          height: 15,
          width: 35,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5), topRight: Radius.circular(5)),
          ),
          child: const Center(
              child: Text(
            "Sale",
            style: TextStyle(fontSize: 12),
          )),
        ),
      );
    }
  }

  getStock(String stock) {
    if (stock == "instock") {
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
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    } else {
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
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    }
  }

  getImage() {
    if (widget.productList[widget.index]["images"].length != 0) {
      return Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.productList[widget.index]["images"].length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  widget.productList[widget.index]["images"][index]['src'],
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
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCart(),
                      ));
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Image.asset(
        "assets/no-image.png",
        fit: BoxFit.contain,
      );
    }
  }

  addToCart(List attribute) {
    if (attribute.isEmpty) {
      ProductFunction().addToCart(
          widget.productList, widget.index, context, 'L', 'Black', 'false');
    } else {
      ProductFunction().addToCart(
          widget.productList,
          widget.index,
          context,
          widget.productList[widget.index]["attributes"][1]["options"]
              [selectedSize],
          widget.productList[widget.index]["attributes"][0]["options"]
              [selectedColor],
          'true');
    }
  }

  getAttribute(List attribute) {
    if (attribute.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              "Available " +
                  widget.productList[widget.index]["attributes"][1]['name']
                      .toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: smallTextSize,
                  color: Theme.of(context).highlightColor),
            ),
          ),
          Row(
            children: [
              for (int i = 0;
                  i <
                      widget
                          .productList[widget.index]["attributes"][1]['options']
                          .length;
                  i++)
                GestureDetector(
                  onTap: () {
                    selectedSize = i;
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          // width: getSBorderWidth(i)
                        ),
                        color: ProductFunction()
                            .getSelectedSizeColor(i, context, selectedSize),
                      ),
                      height: 20,
                      width: 50,
                      child: Center(
                        child: Text(
                          widget.productList[widget.index]["attributes"][1]
                                  ['options'][i]
                              .toString(),
                          style: TextStyle(
                              color: Theme.of(context).highlightColor),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              "Available " +
                  widget.productList[widget.index]["attributes"][0]['name']
                      .toString(),
              style: TextStyle(
                  fontSize: smallTextSize,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).highlightColor),
            ),
          ),
          Row(
            children: [
              for (int i = 0;
                  i <
                      widget
                          .productList[widget.index]["attributes"][0]['options']
                          .length;
                  i++)
                GestureDetector(
                  onTap: () {
                    selectedColor = i;
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: ProductFunction()
                                .getSelectedColorBorderWidth(i, selectedColor)),
                        color: ProductFunction().getProductColor(
                          widget.productList[widget.index]["attributes"][0]
                                  ['options'][i]
                              .toString(),
                        ),
                      ),
                      height: 20,
                      width: 20,
                    ),
                  ),
                )
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              "Available Size",
              style: TextStyle(
                  fontSize: smallTextSize,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).highlightColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              selectedSize = 0;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    // width: getSBorderWidth(i)
                  ),
                  color: ProductFunction()
                      .getSelectedSizeColor(0, context, selectedSize),
                ),
                height: 20,
                width: 50,
                child: Center(
                  child: Text(
                    "L",
                    style: TextStyle(color: Theme.of(context).highlightColor),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              "Available Colors",
              style: TextStyle(
                  fontSize: smallTextSize,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).highlightColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              selectedColor = 0;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: ProductFunction()
                          .getSelectedColorBorderWidth(0, selectedColor)),
                  color: ProductFunction().getProductColor('black'),
                ),
                height: 20,
                width: 20,
              ),
            ),
          )
        ],
      );
    }
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
            widget.productList[widget.index]["name"].toString(),
            style: TextStyle(
              fontSize: smallTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return Container(
                        height: displayHeight(context) * 0.45,
                        width: displayWidth(context) * 1,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: getImage(),
                      );
                    },
                    openBuilder: (BuildContext _, VoidCallback closeContainer) {
                      return ImageView(
                          productList: widget.productList, index: widget.index);
                    },
                    onClosed: (_) => {},
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
                              _getContainer(widget.productList, widget.index),
                              SizedBox(
                                width: displayWidth(context) * 0.8,
                                child: Text(
                                  widget.productList[widget.index]["name"]
                                      .toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).highlightColor,
                                    fontSize: smallTextSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(2)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductFunction().detailedPriceText(
                                      widget.productList,
                                      widget.index,
                                      context),
                                  getStock(widget.productList[widget.index]
                                      ["stock_status"]),
                                ],
                              )
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: getAttribute(
                            widget.productList[widget.index]["attributes"]),
                      )),

                  // const Padding(padding: EdgeInsets.all(1.5)),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontSize: smallTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Html(
                          data: widget.productList[widget.index]
                                  ["short_description"]
                              .toString(),
                          style: {
                            "h1": Style(color: Colors.red),
                            "p": Style(color: Theme.of(context).highlightColor)
                          })),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Text(
                      "Specification",
                      style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontSize: smallTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Html(
                          data: widget.productList[widget.index]["description"]
                              .toString(),
                          style: {
                            "h1": Style(color: Colors.red),
                            "p": Style(color: Theme.of(context).highlightColor)
                          })),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Text(
                      "Additional Info",
                      style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontSize: smallTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Html(
                          data:
                              "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>",
                          style: {
                            "h1": Style(color: Colors.red),
                            "p": Style(color: Theme.of(context).highlightColor)
                          })),

                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //   child: SizedBox(
                  //     height: 300,
                  //     child: DefaultTabController(
                  //       length: 3,
                  //       child: Scaffold(
                  //         appBar: PreferredSize(
                  //           preferredSize: const Size.fromHeight(50),
                  //           child: AppBar(
                  //             elevation: 0,
                  //             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  //             automaticallyImplyLeading: false,
                  //             title: TabBar(
                  //                 indicatorColor: Theme.of(context).primaryColor,
                  //                 indicatorSize: TabBarIndicatorSize.label,
                  //                 tabs: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(bottom: 5),
                  //                     child: Text("Description", style: TextStyle(
                  //                       color: Theme.of(context).highlightColor,
                  //                       fontSize: displayWidth(context)*0.035,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(bottom: 5),
                  //                     child: Text("Specification", style: TextStyle(
                  //                       color: Theme.of(context).highlightColor,
                  //                       fontSize: displayWidth(context)*0.035,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(bottom: 5),
                  //                     child: Text("Additional Info", style: TextStyle(
                  //                       color: Theme.of(context).highlightColor,
                  //                       fontSize: displayWidth(context)*0.034,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ]
                  //             ),
                  //           ),
                  //         ),
                  //         body: TabBarView(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(20),
                  //               child: Text(
                  //                 widget.productList[widget.index]["short_description"].toString(),
                  //                 style: TextStyle(
                  //                     fontSize: 13,
                  //                     color: Theme.of(context).highlightColor,
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  //               child: Text(
                  //                 widget.productList[widget.index]["description"].toString(),
                  //                 style: TextStyle(
                  //                     fontSize: 13,
                  //                   color: Theme.of(context).highlightColor,
                  //
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  //               child: Text(
                  //                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  //                 style: TextStyle(
                  //                     fontSize: 13,
                  //                   color: Theme.of(context).highlightColor,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     ),
                  //   ),
                  // ),
                  //productListing(),
                ],
              );
            }, childCount: 1))
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
                      side: BorderSide(
                          width: 1.5, color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      ProductFunction().addToWList(
                          widget.productList, widget.index, context, setState);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProductFunction().getWIcon(widget.productList,
                              wishList, widget.index, context),
                          Text(
                            ProductFunction()
                                .getWText(
                                    widget.productList, wishList, widget.index)
                                .toString(),
                            style: TextStyle(
                              color: Theme.of(context).highlightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
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
                      addToCart(widget.productList[widget.index]["attributes"]);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            "Add To Cart",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
