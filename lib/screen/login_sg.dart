import 'package:flutter/material.dart';
import 'enlist_sg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'image_upload.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var dropdownvalue;
  var _errorMessage;
  int userlen = 0;
  List<dynamic> categoryItemlist = [];
  List<dynamic> userlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: const Text('Choose Location'),
              items: categoryItemlist.map((item) {
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
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              controller: _usernameController,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                await getUser();
                print("List $userlist");
                //print(userlist[0]["UserName"]);
                userlen = userlist.length;

                //userlen = 1;
//                if (username == 'admin' && password == 'admin') {
                if (userlen == 1 &&
                    username == userlist[0]["UserName"] &&
                    password == userlist[0]["UserPass"]) {
                  print('ok');
                  DocCall();
                } else {
                  invaliddoc();
//                  showAlertDialog(context);
//                  print('Not ok');
//                  setState(() {
//                    _errorMessage = 'Invalid username or password';
//                  });
                }
                // Perform signup logic here
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = const AlertDialog(
      title: Text("ERROR"),
      content: Text("INVALID CREDENTIALS"),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getAllCategory() async {
    //const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    setState(() {
      categoryItemlist = jsonDecode(body);
    });
  }

  Future getUser() async {
    int LocId;
    if (dropdownvalue != null) {
      LocId = dropdownvalue;
    } else {
      LocId = 0;
    }
    final usrname = _usernameController.text;
    final url =
        'http://rcssoft.in/DocMgmt/api/User/?IdUsr=0&UserName=$usrname&LocId=$LocId';
    //const url = 'http://rcssoft.in/DocMgmt/api/User/?IdUsr=0&UserName=&LocId=0';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    if (jsonDecode(body) != null) {
      setState(() {
        userlist = jsonDecode(body);
      });
    } else {
      setState(() {
        userlist.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
    //getUser();
  }

  void DocCall() {
    const DocumentUploadForm();
    //ImageUploadScreen();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocumentUploadForm()));
        //MaterialPageRoute(builder: (context) => ImageUploadScreen()));
  }

  void invaliddoc() {
    showAlertDialog(context);
    print('Not ok');
    setState(() {
      _errorMessage = 'Invalid username or password';
    });
  }
}
