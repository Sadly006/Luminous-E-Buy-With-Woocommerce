import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Functions/map_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MapPage2 extends StatefulWidget {
  MapPage2({Key? key, required this.myIcon, required this.currentLocation}) : super(key: key);
  LocationData currentLocation;
  BitmapDescriptor myIcon;


  @override
  _MapPage2State createState() => _MapPage2State();
}

class _MapPage2State extends State<MapPage2> {

  bool isMapCreated = false;
  late String message;
  List<dynamic> pos = [0.0, 0.0];

  String darkMapStyle = "";
  String lightMapStyle = "";

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = <Marker>{};

  late StreamSubscription<LocationData> subscription;
  late LocationData currentLocation;
  late LocationData destinationLocation;
  late Location location;

  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late double destLat;
  late double destLon;
  bool routing = false;

  Socket socket2 = io(API().mapServerUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build()
  );


  @override
  void initState() {
    super.initState();
    currentLocation = widget.currentLocation;
    socket2.connect();
    location = Location();
    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
      MapFunctions().updatePinsOnMap2(context, currentLocation, setState, _marker, socket2, widget.myIcon, destLat, destLon, polylinePoints, _controller, polylineCoordinates,);
    });
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
        : SafeArea(
            child: Scaffold(
              body: GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: true,
                markers: _marker,
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  isMapCreated = true;
                  MapFunctions().showLocationPinsOnMap2(currentLocation, _marker);
                  changeMapMode();
                },
              ),
            ),
          );
  }
}