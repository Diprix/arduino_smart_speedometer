// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:bike_speed/pages/disconnected.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import 'page.dart';
import 'package:wakelock/wakelock.dart';


final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapUiPage extends ExamplePage {
  BluetoothDevice dispositivo;
  MapUiPage(this.dispositivo) : super(const Icon(Icons.map), 'User interface');

  @override
  Widget build(BuildContext context) {
    return MapUiBody(dispositivo);
  }
}

class MapUiBody extends StatefulWidget {
  BluetoothDevice dispositivo;
  MapUiBody(this.dispositivo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11,
  );

  CameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  final bool _isMoving = true;
  final bool _compassEnabled = true;
  final bool _myLocationButtonEnabled = true;
  final MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  MapType _mapType = MapType.standard;
  final bool _rotateGesturesEnabled = true;
  final bool _scrollGesturesEnabled = true;
  final bool _pitchGesturesEnabled = true;
  final bool _zoomGesturesEnabled = true;
  final bool _myLocationEnabled = true;
  bool _enableTraffic = true;
  final TrackingMode _trackingMode = TrackingMode.followWithHeading;

  FlutterBlue flutterBlue = FlutterBlue.instance;

  String speed = 's: 0.00/d: 0.0';
  String light = 'v: 0.00/thr: 0.0';
  String battery = 't: 0.00/c: 0.0';
  int lightStatus = 0;
  int autoLight = 0;
  int enableLightSensor = 0;

  List<String> rawData = [];

  double batteryMin = 0.00;
  double batteryMax = 0.00;


  @override
  void initState() {
    super.initState();

    if (!kDebugMode) {
      widget.dispositivo.connect();
    }

    readData();
    Wakelock.enable();

  }

  @override
  void dispose() {
    super.dispose();
  }

  // Widget _compassToggler() {
  //   return TextButton(
  //     child: Text('${_compassEnabled ? 'disable' : 'enable'} compass'),
  //     onPressed: () {
  //       setState(() {
  //         _compassEnabled = !_compassEnabled;
  //       });
  //     },
  //   );
  // }
  //
  // Widget _zoomBoundsToggler() {
  //   return TextButton(
  //     child: Text(_minMaxZoomPreference.minZoom == null
  //         ? 'bound zoom'
  //         : 'release zoom'),
  //     onPressed: () {
  //       setState(() {
  //         _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
  //             ? const MinMaxZoomPreference(12.0, 16.0)
  //             : MinMaxZoomPreference.unbounded;
  //       });
  //     },
  //   );
  // }
  //
  Widget _mapTypeCycler() {
    final MapType nextType =
        MapType.values[(_mapType.index + 1) % MapType.values.length];
    return IconButton(
      icon:
      const Icon(Icons.map, color: Colors.blue, size: 30,),
      onPressed: () {
        setState(() {
          _mapType = nextType;
        });
        Fluttertoast.showToast(
          msg: nextType.name,
          fontSize: 15.0,
        );
      },
    );
  }
  //
  // Widget _rotateToggler() {
  //   return TextButton(
  //     child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
  //     onPressed: () {
  //       setState(() {
  //         _rotateGesturesEnabled = !_rotateGesturesEnabled;
  //       });
  //     },
  //   );
  // }
  //
  // Widget _scrollToggler() {
  //   return TextButton(
  //     child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
  //     onPressed: () {
  //       setState(() {
  //         _scrollGesturesEnabled = !_scrollGesturesEnabled;
  //       });
  //     },
  //   );
  // }
  //
  // Widget _tiltToggler() {
  //   return TextButton(
  //     child: Text('${_pitchGesturesEnabled ? 'disable' : 'enable'} tilt'),
  //     onPressed: () {
  //       setState(() {
  //         _pitchGesturesEnabled = !_pitchGesturesEnabled;
  //       });
  //     },
  //   );
  // }
  //
  // Widget _zoomToggler() {
  //   return TextButton(
  //     child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
  //     onPressed: () {
  //       setState(() {
  //         _zoomGesturesEnabled = !_zoomGesturesEnabled;
  //       });
  //     },
  //   );
  // }
  //
  // Widget _myLocationToggler() {
  //   return TextButton(
  //     child: Text(
  //         '${_myLocationEnabled ? 'disable' : 'enable'} my location annotation'),
  //     onPressed: () {
  //       setState(() {
  //         _myLocationEnabled = !_myLocationEnabled;
  //       });
  //     },
  //   );
  // }
  //
  // Widget _myLocationButtonToggler() {
  //   return TextButton(
  //     child: Text(
  //         '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
  //     onPressed: () {
  //       setState(() {
  //         _myLocationButtonEnabled = !_myLocationButtonEnabled;
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final AppleMap appleMap = AppleMap(
      onMapCreated: onMapCreated,
      trackingMode: _trackingMode,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: _compassEnabled,
      minMaxZoomPreference: _minMaxZoomPreference,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      pitchGesturesEnabled: _pitchGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      padding: const EdgeInsets.only(top: 45, right: 0),
      onCameraMove: _updateCameraPosition,

      /*
      Da inserire in un controllo apposito
       */
      trafficEnabled: _enableTraffic,
      mapType: _mapType,
    );

    return Scaffold(
        body: Stack(
      children: [
        Positioned(child: appleMap),
        Positioned(
            bottom: 35,
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: speedometer(),
            ),
        ),
        Positioned(
          bottom: 190,
          left: 15,
          child: Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white ,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: _mapTypeCycler()
            ),

          ),
        ),
        Positioned(
          bottom: 250,
          left: 15,
          child: Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white ,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
                child: IconButton(
                  icon:
                  Icon(Icons.car_crash, color: _enableTraffic ? Colors.blue : Colors.grey, size: 30,),
                  onPressed: () {
                    setState(() {
                      _enableTraffic = !_enableTraffic;
                    });
                  },
                )
            ),

          ),
        ),
      ],
    ));
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void onMapCreated(AppleMapController controller) {
    setState(() {
      _isMapCreated = true;
    });
  }


  Widget speedometer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54 ,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        children: [
          ///SPEED
          Positioned(
            bottom: 0,
            top: -50,
            left: 5,
            child: SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    speed.split('s: ')[1].split('/')[0].split('.')[0].replaceAll('\n', ''),
                    style: GoogleFonts.teko(fontSize: 180),
                  ),
                  Text(
                    'km/h',
                    style: GoogleFonts.teko(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          ///BATTERY
          Positioned(
            top: 5,
            right: 100,
            child: GestureDetector(
              onLongPress: (){
                widget.dispositivo.connect();
                HapticFeedback.heavyImpact();

              },
              child: Row(
                children: [
                  const Icon(
                    UniconsLine.battery_bolt,
                    size: 30,
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    '${battery.split('t: ')[1].split('/')[0]}v',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          ///LIGHT
          Positioned(
            top: 5,
            right: 10,
            child: IconButton(
                onPressed: () async {
                  HapticFeedback.heavyImpact();

                  List<BluetoothService> services =
                  await widget.dispositivo.discoverServices();
                  services.forEach((service) async {
                    var characteristics = service.characteristics;
                    for (BluetoothCharacteristic c
                    in characteristics) {
                      await c.write(utf8.encode('light_on'));

                    }
                  });
                },
                icon: Icon(
                  lightStatus != 0 ? Icons.lightbulb_rounded : Icons.lightbulb_outline ,
                  size: 30,
                  color: lightStatus != 0 ? Colors.amber : Colors.white,
                )),
          ),
          Visibility(
            visible: autoLight == 1,
            child: Positioned(
              top: 35,
              right: 2,
              child: TextButton(
                onPressed: () async {
                  List<BluetoothService> services =
                      await widget.dispositivo.discoverServices();
                  for (var service in services) {
                    var characteristics = service.characteristics;
                    for (BluetoothCharacteristic c
                    in characteristics) {
                      await c.write(utf8.encode('auto_light'));

                    }
                  }
                },
                child: const Text('AUTO', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // decoration: autoLight == 1 ? TextDecoration.none : TextDecoration.lineThrough,
                ),),
              )
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Text(
                  speed.split('d: ')[1].replaceAll('\n', ''),
                  style: GoogleFonts.teko(fontSize: 35),
                ),
                Text(
                  ' km',
                  style: GoogleFonts.teko(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void readData() async {



    List<BluetoothService> services =
    await widget.dispositivo.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        List<int> value = await c.read();

        await c.setNotifyValue(true);
        c.value.listen((values) {

          debugPrint('values: ${values}');
          debugPrint('values decoded: ${utf8.decode(values)}');
          debugPrint('c.deviceId: ${c.deviceId}'); //Importante

          setState(() {
            //rawData.insert(0, utf8.decode(values));
            if (utf8.decode(values).contains('s: ') &&
                utf8.decode(values).contains('/d: ')) {
              speed = utf8.decode(values);
              debugPrint('speed: $speed');
            } else {
              speed = speed;
            }
            if (utf8.decode(values).contains('t: ') &&
                utf8.decode(values).contains('/c: ')) {
              battery = utf8.decode(values);
              debugPrint('battery: $battery');
            }

            if (utf8.decode(values).contains('thr: ') &&
                utf8.decode(values).contains('/v: ')) {
              light = utf8.decode(values);
              debugPrint('battery: $battery');
            }

            if (utf8.decode(values).contains('ligth_status: ')) {
              lightStatus = int.parse(utf8.decode(values).split(': ')[1]);
            }
            if (utf8.decode(values).contains('auto_light: ')) {
              autoLight = int.parse(utf8.decode(values).split(': ')[1]);
            }
            if (utf8.decode(values).contains('enable_sensor: ')) {
              enableLightSensor = int.parse(utf8.decode(values).split(':')[1]);
              debugPrint('********************* $enableLightSensor **********************');

            }

          });
        });
      }
    });
  }
}
