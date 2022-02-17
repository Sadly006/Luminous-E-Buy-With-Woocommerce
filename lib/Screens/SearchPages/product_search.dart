import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../APIs/apis.dart';
import '../../Services/woocommerce_api_call.dart';
import '../product_details.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({Key? key}) : super(key: key);

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  String selectedProduct = "";
  final _text = TextEditingController();
  List searchResult = [];
  bool isLoading = false;
  late String consSecret;
  late String consKey;


  @override
  void initState() {
    super.initState();
    _text.addListener(searchSuggestion);
  }

  void searchSuggestion() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI = WoocommerceAPI(
        url: API().productApi,
        consumerKey: consKey,
        consumerSecret: consSecret);
    final response = await woocommerceAPI.getAsync("");
    searchResult = jsonDecode(response.body);
    print(searchResult.length);
    setState(() {
      isLoading = false;
    });
  }

  getStock(String stock){
    if(stock=="instock"){
      return Container(
        width: 60,
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

  getResult(){
    if(isLoading == true){
      return Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("assets/product.gif"),
        ),
      );
    }
    else{
      if(searchResult.isEmpty){
        return const Center(
          child: Text("No Result"),
        );
      }
      else{
        return ListView.builder(
            itemCount: searchResult.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: EdgeInsets.all(2),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetails(productList2: searchResult, index: index)
                        )
                    );
                  },
                  child: ListTile(
                      leading: SizedBox(
                        height: displayHeight(context)*0.5,
                        child: Image.network(searchResult[index]["images"][0]['src'].toString(), fit: BoxFit.cover,),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                searchResult[index]["name"].toString(),
                                style: Theme.of(context).textTheme.subtitle1
                              ),
                              Padding(padding: EdgeInsets.only(top: 2)),
                              Text(
                                "\$"+searchResult[index]["price"].toString(),
                                style: Theme.of(context).textTheme.headline6
                              )
                            ],
                          ),
                          getStock(searchResult[index]["stock_status"].toString())
                        ],
                      )
                  ),
                ),
              );
            }
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _text,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          SizedBox(
            height: displayHeight(context)*0.75,
            child: getResult(),
          ),
        ],
      ),
    );
  }
}


