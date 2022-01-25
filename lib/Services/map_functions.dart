import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/rating_functions.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/seller_overview.dart';
import 'package:luminous_e_buy/Services/socket_func.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';


class MapFunctions {


  //String serverUrl = "https://ea8c-103-203-92-9.ngrok.io";


  distanceCalculator(List points) {
    var p = 0.017453292519943295;
    var c = cos;

    double totalDistance = 0;
    double distance = 0;
    for(var i = 0; i < points.length-1; i++){
      distance = (0.5 - c((points[i+1].latitude - points[i].latitude) * p)/2 + c(points[i].latitude * p) * c(points[i+1].latitude * p) * (1 - c((points[i+1].longitude - points[i].longitude) * p))/2);
      totalDistance += 12742 * asin(sqrt(distance));
    }

    return totalDistance;
  }


  getProfile(String id, BuildContext context, List<LatLng>passingCoordinates, List<LatLng> points, Socket socket){
    List<LatLng>passCoOrd = [];
    return showMaterialModalBottomSheet(
      expand: false,
      enableDrag: true,
      bounce: true,
      context: context,
      builder: (context) =>SizedBox(
        height: 300,
        width: displayWidth(context)*0.8,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.remove,
                    size: 50,
                    color: Colors.grey,
                  )
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
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
                                  id,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 25
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                            "\$150",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: getDistance(points, context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: RatingFunctions().getShopRating(1, shops),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      height: 50,
                      width: displayWidth(context)*0.8,
                      child: GestureDetector(
                          child: Card(
                            elevation: 8,
                            child: Center(
                              child: Text(
                                  "Show More",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 20
                                  )
                              ),
                            ),
                          ),
                          onTap: () {
                            passCoOrd=passingCoordinates;
                            showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => SafeArea(
                                  child: SizedBox(
                                    height: displayHeight(context),
                                    child: Seller(points: points, id: id, passingCoordinates: passCoOrd,),
                                  ),
                                )
                            );
                          }
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getDistance(List points, BuildContext context) {
    return Text(
        "Distance: "+distanceCalculator(points).toStringAsFixed(2)+"km",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).accentColor,
        )
    );
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? double.infinity)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1 ?? 0, y1 ?? 0),
      southwest: LatLng(x0 ?? 0, y0 ?? 0),
    );
  }

  void setPolyLines(BuildContext context, Set polylines, double lat, double lon, String id, PolylinePoints polylinePoints, LocationData currentLocation, Completer mainController, List<LatLng> polylineCoordinates, List<LatLng> passingCoordinates, Socket socket1, Function setState) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCqxwRwQnYK4_cZ6I3El5SlGN3Im_Y4yp4",
      PointLatLng(currentLocation.latitude ?? 23.751131, currentLocation.longitude ?? 90.387167),
      PointLatLng(lat, lon),
      travelMode: TravelMode.driving,
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      LatLngBounds bounds = MapFunctions().boundsFromLatLngList(polylineCoordinates);
      final GoogleMapController controller = await mainController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

      setState(() {
        polylines.add(Polyline(
            width: 5,
            polylineId: const PolylineId("poly"),
            //color: const Color.fromRGBO(141, 15, 15, 1),
            color: Theme.of(context).accentColor,
            points: polylineCoordinates));
        passingCoordinates.clear();
        passingCoordinates.add(LatLng(lat, lon));
        passingCoordinates.add(LatLng(currentLocation.latitude ?? 23.751131, currentLocation.longitude ?? 90.387167));
        getProfile(id, context, passingCoordinates, polylineCoordinates, socket1);
        SocketFunctions().connectMap1(LatLng(currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193), socket1);
      });
      print(polylineCoordinates);
    }
  }

  void updatePinsOnMap1(BuildContext context, LocationData currentLocation, Function setState, Set marker, Socket socket, BitmapDescriptor myIcon, double destLat, double destLon, PolylinePoints polylinePoints, Completer mainController, List<LatLng> polylineCoordinates, List<LatLng> passingCoordinates, Set polylines,) async {
    final pref = await SharedPreferences.getInstance();
    var livePosition = LatLng(
        currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193);

    setState(() {
      marker.removeWhere((marker) => marker.mapsId.value == 'CurrentLocation');
      marker.add(Marker(
        markerId: const MarkerId('CurrentLocation'),
        position: livePosition,
      ));
      //_connect();
      SocketFunctions().connect(socket, marker, myIcon, destLat, destLon, polylineCoordinates, passingCoordinates, context, polylines, currentLocation, polylinePoints, mainController, setState);
      SocketFunctions().connectMap2(LatLng(
          currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193), pref.getString("email").toString(), "n", socket);
    });
  }

  void updatePinsOnMap2(BuildContext context, LocationData currentLocation, Function setState, Set marker, Socket socket, BitmapDescriptor myIcon, double destLat, double destLon, PolylinePoints polylinePoints, Completer mainController, List<LatLng> polylineCoordinates,) async {
    final pref = await SharedPreferences.getInstance();
    CameraPosition cameraPosition = CameraPosition(
      zoom: 13,
      tilt: 80,
      bearing: 30,
      target: LatLng(
          currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193
      ),
    );

    final GoogleMapController controller = await mainController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var livePosition = LatLng(
        currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193);

    setState(() {
      print(pref.getString("email").toString());
      marker.removeWhere((marker) => marker.mapsId.value == pref.getString("email").toString());
      marker.add(Marker(
        markerId: MarkerId(pref.getString("email").toString()),
        position: livePosition,
      ));
      SocketFunctions().connectMap2(LatLng(
          currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193), pref.getString("email").toString(), "y", socket);
    });
  }

  void setInitialLocation(Location location, LocationData currentLocation, Function setState) async {
    await location.getLocation().then((value) {
      currentLocation = value;
      setState(() {

      });
    });
  }

  void showLocationPinsOnMap1(BuildContext context, Set polylines, LocationData currentLocation, List<LatLng> positions, Set marker, BitmapDescriptor myIcon, double destLat, double destLon, PolylinePoints polylinePoints, Completer mainController, List<LatLng> polylineCoordinates, List<LatLng> passingCoordinates, Socket socket, Function setState) async {
    final pref = await SharedPreferences.getInstance();
    var currentPosition = LatLng(
        currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193);
    positions.add(currentPosition);
    marker.add(Marker(
      markerId: const MarkerId('CurrentLocation'),
      position: currentPosition,
    ));

    positionList.asMap().forEach((index, value) {
      if(pref.getString("email").toString()!=positionList[index]["title"])
      {
        positions.add(LatLng(positionList[index]["lat"], positionList[index]["lon"]));
        marker.add(Marker(
            markerId: MarkerId(positionList[index]["title"]),
            position: LatLng(positionList[index]["lat"], positionList[index]["lon"]),
            // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            icon: myIcon,
            infoWindow: InfoWindow(
              title: positionList[index]["title"],
            ),
            onTap: () {
              destLat = positionList[index]["lat"];
              destLon = positionList[index]["lon"];
              polylineCoordinates.clear();
              // setPolyLines(destLat, destLon, positionList[index]["title"]);
              setPolyLines(context, polylines, destLat, destLon, positionList[index]["title"], polylinePoints, currentLocation, mainController, polylineCoordinates, passingCoordinates, socket, setState);

            }
        ));
      }
    });

    LatLngBounds bounds = MapFunctions().boundsFromLatLngList(positions);

    final GoogleMapController controller = await mainController.future;

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
  void showLocationPinsOnMap2(LocationData currentLocation, Set marker) async {
    final pref = await SharedPreferences.getInstance();
    var currentPosition = LatLng(
        currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193);

    marker.add(Marker(
      markerId: MarkerId(pref.getString("email").toString()),
      position: currentPosition,
    ));

  }
}