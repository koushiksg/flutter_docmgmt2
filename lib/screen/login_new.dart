import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// void main() {
//   runApp(const MyApp());
// }

class Login_New extends StatelessWidget {
  const Login_New({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropDownButton',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> categoryItemlist = [];

  // Future getAllCategory() async {
  //   var baseUrl = "http://rcssoft.in/DocMgmt/api/Location?LocId=0,LocName=";

  //   http.Response response = await http.get(Uri.parse(baseUrl));

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     setState(() {
  //       categoryItemlist = jsonData;
  //     });
  //     print (categoryItemlist[0]['LocName']);
  // }

  Future getAllCategory() async {
    print('fetch started');
    const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    //const url = 'http://rcssoft.in/DocMgmt/api/Item?ItNo=1000';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    setState(() {
      categoryItemlist = jsonDecode(body);
    });
    print('fetch complete');
              print(categoryItemlist[0]['LocName']);
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  var dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DropDown List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: const Text('hooseNumber'),
              items: categoryItemlist.map((item) {
              print(item['LocName']);
                return DropdownMenuItem(
                  value: item['LocId'],
                  child: Text(item['LocName'].toString()),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  dropdownvalue = newVal;
                });
              },
              value: dropdownvalue,
            ),
          ],
        ),
      ),
    );
  }
}