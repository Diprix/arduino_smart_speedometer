import 'package:bike_speed/pages/home_flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:unicons/unicons.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({Key? key}) : super(key: key);

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  List<ScanResult> lista = [];

  BluetoothDevice? dispositivo;

  @override
  void initState() {
    super.initState();

    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        setState(() {
          if (r.device.name.length > 1 && !lista.contains(r)) {
            lista.add(r);
          }
          /*if(r.device.id.toString().contains("FA85DC08-2ED3-76B2-9BE0-83B8250C41C3")){
            r.device.connect();
            flutterBlue.stopScan();
            dispositivo = r.device;

          }*/
        });
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

    // flutterBlue.stopScan();
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
            flutterBlue.startScan(timeout: const Duration(seconds: 4));

            flutterBlue.scanResults.listen((results) {
              // do something with scan results
              for (ScanResult r in results) {
                setState(() {
                  if (r.device.name.length > 1 && !lista.contains(r)) {
                    lista.add(r);
                  }
                  /*if(r.device.id.toString().contains("FA85DC08-2ED3-76B2-9BE0-83B8250C41C3")){
            r.device.connect();
            flutterBlue.stopScan();
            dispositivo = r.device;

          }*/


                });
                print('${r.device.name} found! rssi: ${r.rssi}');
              }
            });
          },
        ),
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
                            HomeTest(dispositivo: lista[index].device)));
              },
            );
          }),
    );
  }
}
