import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/category_wise_product_list.dart';
import 'SearchPages/category_search.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        title: const Text(
            "Categories"
        ),
        actions: <Widget>[
          OpenContainer(
            closedColor: Theme.of(context).secondaryHeaderColor,
            closedElevation: 0,
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return Container(
                color: Theme.of(context).secondaryHeaderColor,
                child: IconButton(
                  onPressed: openContainer,
                  icon: const Icon(Icons.search),
                ),
              );
            },
            openBuilder: (BuildContext _, VoidCallback closeContainer) {
              return CategorySearch();
            },
            onClosed: (_) => {},
          ),
        ],
      ),
      body: SizedBox(
        height: displayHeight(context)*1,
        child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              child: SizedBox(
                height: displayHeight(context)*0.25,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductList(categoryID: categoryList[index]['id'].toString(), categoryName: categoryList[index]['title']),
                      )
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(categoryList[index]['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(categoryList[index]['title'],
                          style: Theme.of(context).textTheme.headline1
                        ),
                      ),
                    ),
                  ),
                )
              ),
            );
          }
        ),
      )
    );
  }
}
