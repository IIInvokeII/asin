import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

class Series{
  String serialNumber;
  String seriesName;
  String seriesRating;
  Series({required this.serialNumber, required this.seriesName, required this.seriesRating});
}

void main() => runApp(const MaterialApp(
  home: DBHome(),
));

class DBHome extends StatefulWidget {
  const DBHome({Key? key}) : super(key: key);
  @override
  State<DBHome> createState() => _DBHomeState();
}

class _DBHomeState extends State<DBHome> {
  var serialNumberController = TextEditingController();
  var seriesNameController = TextEditingController();
  var seriesRatingController = TextEditingController();
  final GlobalKey<FormState> seriesForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App that uses Database\n"Series Rating DB"'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[400],
      ),
      body: Form(
        key: seriesForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Serial Number"
                ),
                keyboardType: TextInputType.number,
                controller: serialNumberController,
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter a number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Series Name"
                ),
                keyboardType: TextInputType.text,
                controller: seriesNameController,
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter a Series Name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Series Rating"
                ),
                keyboardType: TextInputType.number,
                controller: seriesRatingController,
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter a rating';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: (){
                    if(seriesForm.currentState!.validate()){
                      addData();
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: const Text('Record Inserted'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK')
                          )
                        ],
                      ));
                    }
                  },
                  child: const Icon(Icons.add,),
                ),
                FloatingActionButton(
                  onPressed: (){
                    if(seriesForm.currentState!.validate()){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('All Records'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context,'OK'),
                                  child: const Text('OK')
                              )
                            ],
                            content: FutureBuilder<List<dynamic>?>(
                              future: viewAll(),
                              builder: (context, snapshot){
                                if(snapshot.hasError){
                                  print('There was an error');
                                }
                                else if(snapshot.connectionState==ConnectionState.waiting){
                                  return const CircularProgressIndicator();
                                }
                                else if(snapshot.hasData){
                                  final List<dynamic>? viewAll =snapshot.data;
                                  return Container(
                                    height: 300,
                                    width: 300,
                                    child: ListView.builder(
                                      itemCount: viewAll?.length,
                                      itemBuilder: (BuildContext context, int index){
                                          return Text(
                                              'S.No.: ${viewAll?[index]['serialNumber']}\nName: ${viewAll?[index]['seriesName']}\nRating: ${viewAll?[index]['seriesRating']}\n'
                                          );
                                      }
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          )
                      );
                    }
                  },
                  child: const Icon(FontAwesomeIcons.eye),
                ),
                FloatingActionButton(
                  onPressed: (){
                    if(seriesForm.currentState!.validate()){
                      update();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Record Updated'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK')
                              )
                            ],
                          )
                      );
                    }
                  },
                  child: const Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  onPressed: (){
                    if(seriesForm.currentState!.validate()){
                      deleteRec();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Record Updated'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK')
                              )
                            ],
                          )
                      );
                    }
                  },
                  child: const Icon(Icons.delete),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  String dbUri = 'http://10.17.65.186:5000';
  Future<void> addData() async{
    Series s1 = Series(
        serialNumber: serialNumberController.text,
        seriesName: seriesNameController.text,
        seriesRating: seriesRatingController.text);
    final response = await post(
      Uri.parse('$dbUri/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'serialNumber': s1.serialNumber,
        'seriesName': s1.seriesName,
        'seriesRating': s1.seriesRating,
      }
    );
  }

  Future<List> viewAll() async{
    Response response = await get(
      Uri.parse('$dbUri/view_all'),
    );
    Map data = json.decode(response.body);
    List data1 = data['result'];
    return data1;
  }
  Future<void> update() async{
    Series s1 = Series(
        serialNumber: serialNumberController.text,
        seriesName: seriesNameController.text,
        seriesRating: seriesRatingController.text
    );
    final response = await post(
      Uri.parse('$dbUri/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'serialNumber': s1.serialNumber,
        'seriesName': s1.seriesName,
        'seriesRating': s1.seriesRating
      }
    );
  }

  Future<void> deleteRec() async{
    Series s1 = Series(
        serialNumber: serialNumberController.text,
        seriesName: seriesNameController.text,
        seriesRating: seriesRatingController.text
    );
    final response = await delete(
        Uri.parse('$dbUri/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'serialNumber': s1.serialNumber,
        }
    );
  }
}