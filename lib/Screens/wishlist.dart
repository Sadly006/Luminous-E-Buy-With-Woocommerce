import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/product_details.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {

  textShortener(String name) {
    if(name.length>16){
      return name.replaceRange(16, (name.length), "...");
    }
    else{
      return name;
    }
  }

  getImage(int index){
    if(wishList[index]["images"].length!=0){
      return DecorationImage(
        image: NetworkImage(
            wishList[index]["images"][0]["src"].toString()
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

  _getContainer(List product, int index){
    if(product[index]["discount"].toString()=='0'){
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

  _getPriceText(List product, int index) {
    if(product[index]["doNotApplyDiscounts"].toString()=='0'){
      return Text(
        "BDT " + product[index]["mrp"].toString(),
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "BDT " + (product[index]["price"] - (product[index]["price"]*product[index]["doNotApplyDiscounts"]/100)).toString(),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 5)),
              Text(
                  "BDT " + (product[index]["price"]).toString(),
                  style: Theme.of(context).textTheme.headline3
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(3)),
        ],
      );
    }
  }

  _getWishList() {
    double itemWidth = displayWidth(context) / 2;
    double itemHeight = 300;

    return SizedBox(
      height: displayHeight(context) * 1,
      width: displayWidth(context) * 1,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount: wishList.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
            child: OpenContainer(
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
                                  image: getImage(index),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: _getContainer(wishList, index)
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      onPressed: () {
                                        wishList.remove(wishList[index]);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.favorite_border, color: Colors.red,),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              textShortener(wishList[index]["name"].toString()),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text(
                              "BDT " + wishList[index]["price"].toString(),
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
                return ProductDetails(productList2: wishList, index: index);
              },
              onClosed: (_) => print('Closed'),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        title: const Text(
          "Wishlist",
        ),
      ),
      body: wishList.isEmpty
          ? SizedBox(
              height: displayHeight(context)*1,
              child: Center(child: Text("You have not wished anything yet",
          style: Theme.of(context).textTheme.subtitle1,)),
          )
          : _getWishList(),
    );
  }
}