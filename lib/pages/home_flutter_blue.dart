import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

class HomeTest extends StatefulWidget {
  BluetoothDevice dispositivo;
  HomeTest({required this.dispositivo, Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  String speed = 's: 0.00/d: 0.0';
  String light = 'v: 0.00/thr: 0.0';
  String battery = 't: 0.00/c: 0.0';
  int lightStatus = 0;
  int autoLight = 0;
  int enableLightSensor = 0;

  List<String> rawData = [];

  @override
  void initState() {
    super.initState();

    readData();
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
              debugPrint(speed);
            } else {
              speed = speed;
            }
            if (utf8.decode(values).contains('t: ') &&
                utf8.decode(values).contains('/c: ')) {
              battery = utf8.decode(values);
              debugPrint(battery);
            }

            if (utf8.decode(values).contains('thr: ') &&
                utf8.decode(values).contains('/v: ')) {
              light = utf8.decode(values);
              debugPrint(battery);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      top: 35,
                      right: 80,
                      child: Text(
                        speed.split('s: ')[1].split('/')[0].split('.')[0],
                        style: GoogleFonts.teko(fontSize: 250),
                      ),
                    ),
                    Positioned(
                      top: 250,
                      right: 30,
                      child: Text(
                        'km/h',
                        style: GoogleFonts.teko(fontSize: 20),
                      ),
                    ),
                    Positioned(
                      top: 300,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'DIST:',
                              style: GoogleFonts.teko(fontSize: 50),
                            ),
                            const Spacer(),
                            Text(
                              speed.split('d: ')[1],
                              style: GoogleFonts.teko(fontSize: 50),
                            ),
                            Text(
                              ' km',
                              style: GoogleFonts.teko(fontSize: 50),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 4,
            child: Container(
              // color: Colors.orangeAccent,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.white12,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${battery.split('t: ')[1].split('/')[0]}v',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //
                          //     },
                          //     icon: const Icon(
                          //       UniconsLine.volume,
                          //       size: 30,
                          //     )),
                          IconButton(
                              onPressed: () {
                                // Stop scanning

                                readData();
                              },
                              icon: const Icon(
                                UniconsLine.play,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () async {
                                //await c.write([0x12, 0x34]);

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
                              icon: const Icon(
                                UniconsLine.lightbulb_alt,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.white12,

                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                      child: Container(
                        height: 360,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            ListTile(
                              title: const Text('LightMode',style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              trailing: Text(lightStatus.toString(),style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              leading: Icon(
                                autoLight == 0 ? UniconsLine.sun : UniconsLine.moon,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 20,),

                            ListTile(
                              title: const Text('Sensor Light',style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),

                              leading: IconButton(
                                  onPressed: () async {
                                    //await c.write([0x12, 0x34]);

                                    List<BluetoothService> services =
                                    await widget.dispositivo.discoverServices();
                                    services.forEach((service) async {
                                      var characteristics = service.characteristics;
                                      for (BluetoothCharacteristic c
                                      in characteristics) {
                                        await c.write(utf8.encode('auto_light'));

                                      }
                                    });
                                  },
                                  icon: Icon(
                                    enableLightSensor == 0 ? UniconsLine.toggle_off : UniconsLine.toggle_on,
                                    size: 30,
                                  )),

                              trailing: IconButton(
                                  onPressed: () async {
                                    //await c.write([0x12, 0x34]);

                                    List<BluetoothService> services =
                                    await widget.dispositivo.discoverServices();
                                    services.forEach((service) async {
                                      var characteristics = service.characteristics;
                                      for (BluetoothCharacteristic c
                                      in characteristics) {
                                        await c.write(utf8.encode('reset_light'));

                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    UniconsLine.refresh,
                                    size: 30,
                                  )),

                              subtitle: Text('live: ${light.split('v: ')[1]}soglia: ${light.split('thr: ')[1].split('/')[0]}',style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              ),

                             ),
                            const SizedBox(height: 20,),

                            ListTile(
                              title: const Text('Reset dist',style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              onTap: () async {
                                //await c.write([0x12, 0x34]);

                                List<BluetoothService> services =
                                await widget.dispositivo.discoverServices();
                                services.forEach((service) async {
                                  var characteristics = service.characteristics;
                                  for (BluetoothCharacteristic c
                                  in characteristics) {
                                    await c.write(utf8.encode('reset_light'));

                                  }
                                });
                              },

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
