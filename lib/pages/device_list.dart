import 'package:bike_speed/pages/apple_map.dart';
import 'package:bike_speed/pages/google_map_test.dart';
import 'package:bike_speed/pages/home.dart';
import 'package:bike_speed/pages/home_flutter_blue_debug.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:unicons/unicons.dart';

import 'home_flutter_blue.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({Key key}) : super(key: key);

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  List<ScanResult> lista = [];

  BluetoothDevice dispositivo;

  @override
  void initState() {
    super.initState();

    scanDevice();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(color: Colors.white,),
            const SizedBox(height: 15,),
            const Text('Connessione alla bicicletta'),

            const SizedBox(height: 35,),
            CupertinoButton(child: const Text('Aggiorna'), onPressed: () => scanDevice()),
          ],
        ),
      )


    );
  }

  scanDevice(){
    flutterBlue.startScan(timeout: const Duration(seconds: 20));

    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        setState(() {
          if (r.device.name.length > 1 && !lista.contains(r)) {
            lista.add(r);
          }



          if(r.device.name.toString().contains("DIPRIX_MTB")){
            flutterBlue.stopScan();

            r.device.connect();
            dispositivo = r.device;

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MapUiPage(dispositivo)));

          }
        });
      }
    });
  }

}
