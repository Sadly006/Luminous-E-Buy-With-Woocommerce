import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Services/map_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Routing extends StatefulWidget {
  Routing({Key? key, required this.passingCoordinates, required this.coordinatePoints, required this.id}) : super(key: key);

  List<LatLng> passingCoordinates = [];
  List<LatLng> coordinatePoints = [];
  String id;

  @override
  _RoutingState createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {

  Socket socket3 = io(API().mapServerUrl,
      OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build()
  );

  bool isMapCreated = false;
  late BitmapDescriptor myIcon;

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = <Marker>{};

  late StreamSubscription<LocationData> subscription;
  late LocationData destinationLocation;

  late String darkMapStyle;
  late String lightMapStyle;

  final Set<Polyline> _polylines = <Polyline>{};
  PolylinePoints polylinePoints = PolylinePoints();

  late double destLat;
  late double destLon;
  late double curLat;
  late double curLon;

  @override
  void initState() {
    super.initState();
    print("PW: "+widget.passingCoordinates.toString());
    socket3.connect();
    Map<String, dynamic> data = {"id": widget.id, "loc": "khjf", "join": "n"};
    socket3.emit("location", data);
    connect();
    loadMapStyles();
    //setInitialLocation();
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), 'assets/bicycle.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  void connect() {
    socket3.on("location", (msg) => {
      print("MessageRT: "+ msg[0].toString()),
      if(msg[0]==widget.id){
        setState(() {
          _marker.removeWhere((marker) => marker.mapsId.value == msg[0].toString());
          _marker.add(Marker(
          markerId: MarkerId(msg[0].toString()),
          position: LatLng(msg[1][0], msg[1][1]),
          icon: myIcon,
          infoWindow: InfoWindow(
          title: msg[0],
          ),
          ));
        })
      }

    });
  }

  void showLocationPins() {
    print("ID: "+widget.id.toString());
    _marker.add(Marker(
      markerId: MarkerId(widget.id.toString()),
      position: widget.passingCoordinates[0],
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      icon: myIcon
    ));
    _marker.add(Marker(
        markerId: const MarkerId("Destination"),
        position: widget.passingCoordinates[1],
    ));
    setState(() {
      print("Pins Set");
      setPolyLines();
    });
  }

  void setPolyLines() async {
    setState(() async {
      LatLngBounds bounds = MapFunctions().boundsFromLatLngList(widget.coordinatePoints);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      _polylines.add(Polyline(
          width: 5,
          polylineId: PolylineId("poly"),
          //color: const Color.fromRGBO(141, 15, 15, 1),
          color: Theme.of(context).accentColor,
          points: widget.coordinatePoints));
    });
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
      zoom: 15,
      tilt: 80,
      bearing: 30,
      target: widget.passingCoordinates[0],
    );

    if (isMapCreated) {
      changeMapMode();
    }

    return SafeArea(
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
            showLocationPins();
            changeMapMode();
          },
        ),
      ),
    );
  }
}
