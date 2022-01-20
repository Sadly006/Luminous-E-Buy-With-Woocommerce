import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Functions/map_functions.dart';
import 'package:luminous_e_buy/Functions/socket_func.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MapPage1 extends StatefulWidget {
  MapPage1({Key? key, required this.myIcon, required this.currentLocation}) : super(key: key);
  BitmapDescriptor myIcon;
  LocationData currentLocation;


  @override
  _MapPage1State createState() => _MapPage1State();
}

class _MapPage1State extends State<MapPage1> {

  bool isMapCreated = false;

  String darkMapStyle = "";
  String lightMapStyle = "";

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = <Marker>{};
  late List<LatLng> positions = [];

  late StreamSubscription<LocationData> subscription;
  late LocationData currentLocation;

  late LocationData destinationLocation;
  late Location location;

  final Set<Polyline> polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> passingCoordinates = [];

  double destLat=0;
  double destLon=0;
  bool routing = false;

  Socket socket1 = io(API().mapServerUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build()
  );


  @override
  void initState(){
    super.initState();
    location = Location();
    socket1.connect();
    currentLocation = widget.currentLocation;
    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
      MapFunctions().updatePinsOnMap1(context, currentLocation, setState, _marker, socket1, widget.myIcon, destLat, destLon, polylinePoints, _controller, polylineCoordinates, passingCoordinates, polylines);
    });
    SocketFunctions().connect(socket1, _marker, widget.myIcon, destLat, destLon, polylineCoordinates, passingCoordinates, context, polylines, currentLocation, polylinePoints, _controller, setState);
    loadMapStyles();
    MapFunctions().setInitialLocation(location, currentLocation, setState);
  }


  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  Future loadMapStyles() async {
    darkMapStyle  = await rootBundle.loadString('assets/dark.json');
    lightMapStyle = await rootBundle.loadString('assets/light.json');
  }

  Future<void>changeMapMode() async {
    final controller = await _controller.future;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("darkTheme") == false) {
      controller.setMapStyle(lightMapStyle);
    } else {
      controller.setMapStyle(darkMapStyle);
    }
  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 13,
      tilt: 80,
      bearing: 30,
      target: currentLocation != null
          ? LatLng(currentLocation.latitude ?? 23.8061939, currentLocation.longitude ?? 90.3771193)
          : const LatLng(23.8061939, 90.3771193),
    );

    if (isMapCreated) {
      changeMapMode();
    }

    return currentLocation == null
      ? Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        )
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: const Text(
              "Road Tracker",
              style: TextStyle(
                  fontSize: 18
              ),
            ),
          ),
          body: SafeArea(
            child: Scaffold(
              body: GoogleMap(
                myLocationButtonEnabled: false,
                compassEnabled: true,
                markers: _marker,
                polylines: polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  isMapCreated = true;
                  MapFunctions().showLocationPinsOnMap1(context, polylines, currentLocation, positions, _marker, widget.myIcon, destLat, destLon, polylinePoints, _controller, polylineCoordinates, passingCoordinates, socket1, setState);
                  changeMapMode();
                },
              ),
            ),
          ),
    );
  }
}