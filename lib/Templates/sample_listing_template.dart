import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screens/product_list.dart';
import 'package:luminous_e_buy/Templates/product_tile.dart';

class SampleListing extends StatefulWidget {
  List<dynamic> sampleProductList = [];
  String catName = '';
  SampleListing({Key? key, required this.sampleProductList, required this.catName}) : super(key: key);

  @override
  _SampleListingState createState() => _SampleListingState();
}

class _SampleListingState extends State<SampleListing> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 0)),
                Row(
                  children: [
                    Text(
                      widget.catName,
                      style: TextStyle( //homePage category name accent
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 0)),
                GestureDetector(
                  onTap: () {
                    productList.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductList(),
                        )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Text(
                      "Show More",
                      style: TextStyle( //show more
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10))
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProductTile(productList: widget.sampleProductList, index: 0, isLoading: false),
              ProductTile(productList: widget.sampleProductList, index: 1, isLoading: false),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 12)),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProductTile(productList: widget.sampleProductList, index: 2, isLoading: false),
              ProductTile(productList: widget.sampleProductList, index: 3, isLoading: false),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(5))
      ],
    );
  }
}
