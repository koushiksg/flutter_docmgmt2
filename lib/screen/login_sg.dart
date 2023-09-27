import 'package:flutter/material.dart';
import 'enlist_sg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                //FutureBuilder(
                    //future: getUser(),
                    //builder: (context, AsyncSnapshot snapshot) {
                      //print("List $userlist");
                      //return const Text("No widget to build");
                      //if (snapshot.hasError) {
                      //  return const Text('error');
                      //}
                      //if (snapshot.data != null) {return const Text('error');}
                    //});
                //print("List $userlist");
                //getUser();
//                if (username == 'admin' && password == 'admin') {
                final Future user2list = getUser();
                print(user2list);
                if (userlen == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DocumentUploadForm()),
                  );
                } else {
                  showAlertDialog(context);
                  setState(() {
                    _errorMessage = 'Invalid username or password';
                  });
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
    //const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    int LocId;
    if (dropdownvalue != null) {
      LocId = dropdownvalue;
    } else {
      LocId = 0;
    }
    final url =
        'http://rcssoft.in/DocMgmt/api/User/?IdUsr=0&UserName=&LocId=$LocId';
    //const url = 'http://rcssoft.in/DocMgmt/api/User/?IdUsr=0&UserName=&LocId=0';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    print(url);
    setState(() {
      userlist = jsonDecode(body);
    });
  return Future.delayed(const Duration(seconds: 2),
      () => throw Exception('Logout failed: user ID is invalid'));
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
    //getUser();
  }
}
