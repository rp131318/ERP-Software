import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globalVariable.dart';

class TabHomePage extends StatefulWidget {
  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 111, bottom: 66),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Breathe Medical Systems",
                  style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: colorBlack5),
                ),
              ),
            ),
            Image.asset("images/logo.png"),
          ],
        ),
      ),
    );
  }
}
