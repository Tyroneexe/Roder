// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roder/googlemaps/location_services.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'maps_provider.dart';

class Mapp extends StatefulWidget {
  const Mapp({Key? key}) : super(key: key);

  @override
  State<Mapp> createState() => MappState();
}

class MappState extends State<Mapp> {
  bool _fromListVisible = false;
  bool _toListVisible = false;

  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _fromPlacesList = [];
  List<dynamic> _toPlacesList = [];

  //
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-26.20553789012317, 28.0530918134435),
    zoom: 14.4746,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //

    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context, listen: false);

    controllerProvider.fromController.addListener(() {
      onChange();
    });

    controllerProvider.toController.addListener(() {
      onChange();
    });

    _setMarker(
      LatLng(-26.20553789012317, 28.0530918134435),
    );
  }

  void onChange() {
    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context, listen: false);
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion1(controllerProvider.fromController.text);
    getSuggestion2(controllerProvider.toController.text);
  }

  void getSuggestion1(String input) async {
    String kPLACES_API_KEY = 'AIzaSyCPljTaSTK1vY7uP7XRUxg2TscBr62FqtY';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    // var data = response.body.toString();

    // print(response.body.toString());
    if (mounted) {
      if (response.statusCode == 200) {
        setState(() {
          _fromPlacesList = jsonDecode(response.body.toString())['predictions'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  void getSuggestion2(String input) async {
    String kPLACES_API_KEY = 'AIzaSyCPljTaSTK1vY7uP7XRUxg2TscBr62FqtY';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    // var data = response.body.toString();

    // print(response.body.toString());
    if (mounted) {
      if (response.statusCode == 200) {
        setState(() {
          _toPlacesList = jsonDecode(response.body.toString())['predictions'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId('marker'), position: point),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeColor: Colors.transparent,
        strokeWidth: 2));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 2,
          color: Colors.blue,
          points: points
              .map(
                (point) => LatLng(point.latitude, point.longitude),
              )
              .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    ControllerProvider controllerProvider =
        Provider.of<ControllerProvider>(context);
    return new Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appbar(),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // from // from //from // from // from // from // from
                        TextFormField(
                          controller: controllerProvider.fromController,
                          decoration: InputDecoration(hintText: "Origin"),
                          onChanged: (value) {
                            // print(value);
                            Provider.of<ControllerProvider>(context,
                                listen: false);
                            setState(() {
                              _fromListVisible = true;
                            });
                          },
                        ),
                        if (_fromListVisible &&
                            controllerProvider.fromController.text.isNotEmpty)
                          Stack(children: [
                            Visibility(
                              visible: _fromListVisible,
                              child: Container(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: _fromPlacesList.length,
                                  itemBuilder: ((context, index) {
                                    return ListTile(
                                      title: Text(_fromPlacesList[index]
                                          ['description']),
                                      onTap: () {
                                        controllerProvider.fromController.text =
                                            _fromPlacesList[index]
                                                ['description'];
                                        _fromListVisible = false;
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ]),
                        // to // to // to // to // to // to // to // to // to // to
                        TextFormField(
                          controller: controllerProvider.toController,
                          decoration: InputDecoration(hintText: "Destination"),
                          onChanged: (value) {
                            // print(value);
                            Provider.of<ControllerProvider>(context,
                                listen: false);
                            setState(() {
                              _toListVisible = true;
                            });
                          },
                        ),
                        if (_toListVisible &&
                            controllerProvider.toController.text.isNotEmpty)
                          Stack(children: [
                            Visibility(
                              visible: _toListVisible,
                              child: Container(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: _toPlacesList.length,
                                  itemBuilder: ((context, index) {
                                    return ListTile(
                                      title: Text(
                                          _toPlacesList[index]['description']),
                                      onTap: () {
                                        controllerProvider.toController.text =
                                            _toPlacesList[index]['description'];
                                        setState(() {
                                          _toListVisible = false;
                                        });
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ]),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          var directions = await LocationService()
                              .getDirections(
                                  controllerProvider.fromController.text,
                                  controllerProvider.toController.text);
                          _goToPlace(
                              directions['start_location']['lat'],
                              directions['start_location']['lng'],
                              directions['bounds_ne'],
                              directions['bounds_sw']);

                          _setPolyline(directions['polyline_decoded']);
                          // print(directions['polyline_decoded']);
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              markers: _markers,
              polylines: _polylines,
              polygons: _polygons,
              mapType: MapType.normal,
              initialCameraPosition: _kInitialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _appbar() {
    return AppBar(
      iconTheme:
          IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      title: Text(
        'Google Maps',
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
          northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
        ),
        25));

    _setMarker(LatLng(lat, lng));
  }
}
