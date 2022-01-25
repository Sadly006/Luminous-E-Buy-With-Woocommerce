import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'map_functions.dart';

class SocketFunctions {

  connect(Socket socket, Set marker, BitmapDescriptor myIcon, double destLat, double destLon, List<LatLng> polylineCoordinates, List<LatLng> passingCoordinates, BuildContext context, Set polylines, LocationData currentLocation, PolylinePoints polylinePoints, Completer controller, Function setState) {
    socket.on("location", (msg) => {
      print("Message1: "+ msg.toString()),
      marker.removeWhere((marker) => marker.mapsId.value == msg[0]),
      marker.add(Marker(
          markerId: MarkerId(msg[0]),
          position: LatLng(msg[1][0], msg[1][1]),
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          icon: myIcon,
          infoWindow: InfoWindow(
            title: msg[0],
          ),
          onTap: () {
            destLat = msg[1][0];
            destLon = msg[1][1];
            polylineCoordinates.clear();
            MapFunctions().setPolyLines(context, polylines, destLat, destLon, msg[0], polylinePoints, currentLocation, controller, polylineCoordinates, passingCoordinates, socket, setState);
            //setPolyLines(destLat, destLon, msg[0]);
          }
      )),
    });
  }

  void connectMap1(LatLng cLocation, Socket socket) {
    // socket1.emit("location", cLocation);
    // socket1.onConnect((_) {
    //   print("Connected1");
    // });
  }

  void connectMap2(LatLng cLocation, String title, String join, Socket socket) {
    // socket2.emit("id", "customer");
    // print("JFK");
    // socket2.on("location", (msg) => {
    //   print("Message: "+ msg[0].toString() + " " + msg[1].toString()),
    //   //print("Message: "+ msg),
    //
    // });

    Map<String, dynamic> data = {"title": title, "loc": cLocation, "join": join};
    socket.emit("location", data);
    // socket2.onConnect((_) {
    //   print("Connected1");
    // });
  }
}