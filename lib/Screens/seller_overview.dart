import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Templates/parallax.dart';

class Seller extends StatefulWidget {
  List<LatLng> points = [];
  List<LatLng> passingCoordinates = [];
  String id;
  Seller({Key? key, required this.points, required this.id, required this.passingCoordinates}) : super(key: key);

  @override
  _SellerState createState() => _SellerState();
}

class _SellerState extends State<Seller> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.blueGrey,
                  ),
                  child: const Center(
                    child: Text(
                      "DP",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: displayWidth(context)*0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                        widget.id,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          body: const ImageParallax(),
          // body: SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       SizedBox(
          //         height: 250,
          //         width: displayWidth(context),
          //         child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             itemCount: sayedulVairList.length,
          //             itemBuilder: (BuildContext context,int index){
          //               return Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          //                 child: SizedBox(
          //                   height: 200,
          //                   width: 120,
          //                   child: ClipRRect(
          //                     borderRadius: const BorderRadius.all(Radius.circular(10)),
          //                     child: Image.network(
          //                       sayedulVairList[index]["picturesUrls"][0].toString(),
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             }
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(10),
          //         child: GestureDetector(
          //             child: Card(
          //               elevation: 8,
          //               child: Center(
          //                 child: Text(
          //                     "Confirm",
          //                     style: TextStyle(
          //                         color: Theme.of(context).accentColor,
          //                         fontSize: 20
          //                     )
          //                 ),
          //               ),
          //             ),
          //             onTap: () {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => Routing(passingCoordinates: widget.passingCoordinates, coordinatePoints: widget.points, id: widget.id),
          //                   )
          //               );
          //             }
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        )
    );
  }
}

