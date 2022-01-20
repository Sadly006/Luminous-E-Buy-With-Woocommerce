import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Functions/product_functions.dart';
import 'package:luminous_e_buy/Functions/woocommerce_api_call.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/product_details.dart';
import 'package:luminous_e_buy/Screens/shimmer_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductTile extends StatefulWidget {
  List<dynamic> productList = [];
  int index = 0;
  bool isLoading;
  ProductTile({Key? key, required this.productList, required this.index, required this.isLoading});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {

  textShortener(String name) {
    if(name.length>15){
      return name.replaceRange(15, (name.length), "...");
    }
    else{
      return name;
    }
  }

  getImage(){
    if(widget.productList[widget.index]["images"].length!=0){
      return DecorationImage(
        image: NetworkImage(
          widget.productList[widget.index]["images"][0]["src"].toString()
        ),
        fit: BoxFit.cover,
      );

    }
    else{
      return const DecorationImage(
        image: AssetImage(
          "assets/no-image.png"
        ),
        fit: BoxFit.contain,
      );
    }
  }

  getTile(){
    if(widget.isLoading){
      return Container(
          color: Theme.of(context).backgroundColor,
          height: 300,
          width: displayWidth(context) * 0.49,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading(
                isLoading: widget.isLoading,
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
                  ),
                ),
              ),
              ShimmerLoading(
                isLoading: widget.isLoading,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              ShimmerLoading(
                isLoading: widget.isLoading,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  // child: ProductFunction().getPriceText(widget.productList, widget.index, context),
                  child: Container(
                    width: displayWidth(context)*0.2,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          )
      );
    }
    else{
      return OpenContainer(
        closedElevation: 6,
        transitionType: ContainerTransitionType.fadeThrough,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return GestureDetector(
            child: Container(
                color: Theme.of(context).backgroundColor,
                height: 300,
                width: displayWidth(context) * 0.49,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
                          image: getImage(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child: _getContainer()
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                ProductFunction().addToWList(widget.productList, widget.index, context, setState);
                              },
                              icon: ProductFunction().getWIcon(widget.productList, wishList, widget.index, context),
                            ),
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        textShortener(widget.productList[widget.index]["name"].toString()),
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      // child: ProductFunction().getPriceText(widget.productList, widget.index, context),
                      child: Text(
                        "\$ " + widget.productList[widget.index]["price"].toString(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
            ),
            onTap: openContainer,
          );
        },
        openBuilder: (BuildContext _, VoidCallback closeContainer) {
          return ProductDetails(productList2: widget.productList, index: widget.index);
        },
        onClosed: (_) => print('Closed'),
      );
    }
  }

  _getContainer(){
    if(widget.productList[widget.index]["sale_price"].toString()==''){
      return const Padding(padding: EdgeInsets.all(0));
    }
    else{
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          height: 20,
          width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), topLeft: Radius.circular(4)),
          ),
          child: const Center(child: Text("Sale")),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
      child: getTile()
      //child: getTile(),
    );
  }
}