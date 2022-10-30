import 'package:bike_speed/pages/apple_map.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:unicons/unicons.dart';
import 'package:wakelock/wakelock.dart';


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
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart MTB System'),
        leading: IconButton(
          icon: const Icon(
            UniconsLine.refresh,
            size: 30,
          ),
          onPressed: () {
            scanDevice();
          },
        ),
        //
        // actions: [IconButton(
        //   icon: const Icon(
        //     UniconsLine.lightbulb,
        //     size: 30,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 MapUiPage(dispositivo)));
        //   },
        // ),]
      ),
      body: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(lista[index].device.name),
              subtitle: Text(lista[index].device.id.toString()),
              onTap: () {
                lista[index].device.connect();

                dispositivo = lista[index].device;

                flutterBlue.stopScan();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapUiPage(lista[index].device)));
              },
            );
          }),


    );
  }

  scanDevice(){
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    lista.clear();
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        setState(() {
          if (r.device.name.length > 1 && !lista.contains(r)) {
            lista.add(r);
          }
        });

        // if(r.device.name == "DIPRIX_MTB"){
        //   flutterBlue.stopScan();
        //
        //   r.device.connect();
        //   dispositivo = r.device;
        //
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               MapUiPage(dispositivo)));
        //
        // }
      }
    });
  }

}
