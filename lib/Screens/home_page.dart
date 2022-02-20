import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Providers/theme_provider.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/product_list.dart';
import 'package:luminous_e_buy/Templates/sample_listing_template.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'SearchPages/product_search.dart';
import 'categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(delegate: SliverChildBuilderDelegate(
                (BuildContext context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        //color: Theme.of(context).primaryColor,
                        width: displayWidth(context)*1,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                              child: SizedBox(
                                height: displayHeight(context)*0.05,
                                width: displayWidth(context)*0.82,
                                child: OpenContainer(
                                    closedElevation: 6,
                                    closedBuilder: (BuildContext context, VoidCallback openContainer){
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 1),
                                            child: IconButton(
                                              onPressed: openContainer,
                                              icon: const Icon(Icons.search,
                                                color: Colors.black,),
                                            ),
                                          ),
                                          const Text("Search Products",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                    openBuilder: (BuildContext context, VoidCallback closeContainer) {
                                      return ProductSearch();
                                    }
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.brightness_6),
                              onPressed: () {
                                Provider.of<ThemeProvider>(context, listen: false).swapTheme();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                        ),
                        items: carousalImageList.map((item) => ClipRRect(
                          borderRadius: BorderRadius.circular(00),
                          child: Stack(
                              fit: StackFit.loose,
                              children: <Widget>[
                                Card(
                                  // width: displayWidth(context)*0.8,
                                  // height: 300,
                                  elevation: 10,
                                  shadowColor: Theme.of(context).shadowColor,
                                  // color: Theme.of(context).primaryColor,
                                  child: SizedBox(
                                    width: displayWidth(context)*0.8,
                                    height: 300,
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              ]
                          ),
                        )
                        ).toList(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryList(),
                            )
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.categories,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Icon(
                              Icons.arrow_right,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.15,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder:
                          (BuildContext context, int index) =>
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductList(),
                                  )
                              );
                            },
                            child: Padding(padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                // backgroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: ClipOval(
                                    child: Image.network(
                                      categoryImageList[index],
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                ),
                                radius: 43,
                              ),
                            ),
                          )
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SampleListing(sampleProductList: newArrival, catName: "New Arrival"),
                    Padding(padding: EdgeInsets.all(10)),
                    SampleListing(sampleProductList: topPicks, catName: "Top Picks"),
                    Padding(padding: EdgeInsets.all(10)),

                    SampleListing(sampleProductList: forYou, catName: "For You"),
                  ],
                );
              },
              childCount: 1,
            ))
          ],
        )
    );
  }
}