import 'package:clima/services/location.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final Location loc = Location();
  String resultText = "";
  //String _currentAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("$resultText"),
          Center(
            child: RaisedButton(
              onPressed: () {
                loc.getCurrentLocation();
                resultText = "${loc.latitude},${loc.longitude}";
              },
              child: Text('Get Location'),
            ),
          ),
        ],
      ),
    );
  }
}
