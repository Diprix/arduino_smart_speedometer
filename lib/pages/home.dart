import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      top: 60,
                      right: 160,
                      child: Text(
                        '22',
                        style: GoogleFonts.teko(fontSize: 200),
                      ),
                    ),
                    Positioned(
                      top: 175,
                      right: 120,
                      child: Text(
                        '.9',
                        style: GoogleFonts.teko(fontSize: 80),
                      ),
                    ),
                    Positioned(
                      top: 233,
                      right: 70,
                      child: Text(
                        'km/h',
                        style: GoogleFonts.teko(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 3,
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
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () async {
// Some simplest connection :F

                              },
                              icon: const Icon(
                                UniconsLine.volume,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {

                              },
                              icon: const Icon(
                                UniconsLine.setting,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () async {

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
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: Column(
                          children: [


                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
