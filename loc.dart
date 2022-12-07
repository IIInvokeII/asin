import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.lightGreen
  ),
  home: Scaffold(
    appBar: AppBar(
      title: const Text('Location'),
    ),
    body: const Loc(),
  ),
));

class Loc extends StatefulWidget {
  const Loc({Key? key}) : super(key: key);
  @override
  State<Loc> createState() => _LocState();
}
class _LocState extends State<Loc> {
  Location location = Location();
  late LocationData locData;
  bool isLocTrue = false;
  String lat='Lat', long='Long';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: updateLoc,
          child: const Text('Click'),
        ),
        Text(lat),
        Text(long)
      ],
    );
  }
  void updateLoc() async {
    locData = await location.getLocation();
    setState((){
      isLocTrue=true;
    });
    if(isLocTrue){
      lat="${locData.latitude}";
      long="${locData.longitude}";
    }
  }
}
