import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShopProductList extends StatefulWidget {
  final int shopId;
  ShopProductList({Key? key, required this.shopId}) : super(key: key);

  @override
  _ShopProductListState createState() => _ShopProductListState();
}

class _ShopProductListState extends State<ShopProductList> {

  int index=0, increment = 6;
  bool isLoading = false;
  List<Map<String, dynamic>> lazyList = [];

  _followShop(List following, List shops, int index) async {
    int c=0;
    final pref = await SharedPreferences.getInstance();
    if(pref.getString('token') == null) {
      const snackBar = SnackBar(
        content: Text('Sign in to Follow'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if(pref.getString('token') != null) {
      int k=0;
      for(int i=0; i<following.length; i++){
        if(following[i]["id"]==index+1){
          c++;
          k=i;
          break;
        }
      }
      if(c==0) {
        for(int i=0; i<shops.length; i++){
          if(shops[i]["brand"]==shops[index]["brand"]){
            following.add(shops[index]);
            break;
          }
        }
      }
      else if(c!=0){
        following.remove(following[k]);
      }
    }
    setState(() {
      _getWidget(following, productList, index);
    });
  }

  _getWidget(List following, List shops, int index){
    int s=0;
    for(int i=0; i<following.length; i++){
      if(following[i]["id"]==index+1){
        s++;
        break;
      }
    }
    if(s==0) {
      return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
          ),
          onPressed: (){
            _followShop(following, shops, index);
          },
          child: const Text("Follow")
      );
    }
    else if(s!=0){
      return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          ),
          onPressed: (){
            _followShop(following, shops, index);
          },
          child: const Text("Following")
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   toolbarHeight: 100,
        //   flexibleSpace: Container(
        //     color: Theme.of(context).primaryColor,
        //     width: displayWidth(context)*1,
        //     child: Container(
        //       width: displayWidth(context)*1,
        //       decoration: const BoxDecoration(
        //         color: Colors.black45,
        //       ),
        //       child: Center(
        //         child: SizedBox(
        //           width: displayWidth(context)*1,
        //           height: 100,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //                 child: Row(
        //                   children: [
        //                     const Padding(padding: EdgeInsets.all(5)),
        //                     Container(
        //                       decoration: BoxDecoration(
        //                         shape: BoxShape.rectangle,
        //                         borderRadius: const BorderRadius.all(Radius.circular(10)),
        //                         image: DecorationImage(
        //                           image: NetworkImage(shops[widget.shopId]["logo"]),
        //                           fit: BoxFit.contain,
        //                         ),
        //                       ),
        //                       height: 70,
        //                       width: 70,
        //                     ),
        //                     const Padding(padding: EdgeInsets.all(2)),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         Text(
        //                             shops[widget.shopId]["brand"],
        //                             style: Theme.of(context).textTheme.headline4
        //                         ),
        //                         Row(
        //                           children: [
        //                             RatingFunctions().getShopRating(widget.shopId, shops),
        //                             const Padding(padding: EdgeInsets.only(left: 3)),
        //                             Text(
        //                               shops[widget.shopId]["rating"].toString()+"(5)",
        //                             )
        //                           ],
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                   padding: const EdgeInsets.only(right: 5),
        //                   child: _getWidget(followingShops, shops, widget.shopId)
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        //   // title: Text(widget.productList[widget.index]["brand"]),
        // ),
        body: SizedBox(
          width: displayWidth(context)*1,
          height: displayHeight(context)*1,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(2)),
              SizedBox(height: (displayHeight(context)*1)-140,
                  //child: ProductListingTemplate(productList: sayedulVairList,)
              ),
            ],
          ),
        )
      ),
    );
  }
}
