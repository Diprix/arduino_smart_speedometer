import 'package:bike_speed/pages/device_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisconnectedPage extends StatelessWidget {
  const DisconnectedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Text('Bicicletta disconnessa'),

            const SizedBox(height: 35,),
            CupertinoButton(child: const Text('Riconetti'), onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const DeviceList()));
            }),
          ],
        ),
      )
    );
  }
}
