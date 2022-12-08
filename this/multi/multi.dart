import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int randInt=99;
  static FutureOr<int> randGen(int cal){
    var rng = Random();
    return rng.nextInt(100);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Multithreading App",
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Random Number: ",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                "$randInt",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            onPressed: () async{
              int result = await compute(randGen,randInt);
              setState(() {
                randInt = result;
              });
            },
            child: const Text(
              "Press Me!",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
