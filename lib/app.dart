import 'package:bike_speed/pages/device_list.dart';
import 'package:bike_speed/pages/home.dart';
import 'package:bike_speed/pages/home_flutter_blue.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(


      ),
      home: const DeviceList()
    );
  }
}
