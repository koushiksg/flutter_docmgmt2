import 'dart:js_interop';

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
  String _errorMessage = '';
  var dropdownvalue;
   List<dynamic> users = [];
     List<dynamic> categoryItemlist = [];

  // final List<String> _garden_name = [
  //   'Garden A',
  //   'Garden B',
  //   'Garden c',
  //   'Garden D'
  // ];
  @override
  Widget build(BuildContext context) {
    fetchUsers();
      
      final List<dynamic> _garden_name = [
       users[0]['LocName'], 
    users[1]['LocName'],
    users[2]['LocName'],
    users[3]['LocName'],
      ]
      ;
    //   final List<String> _garden_name = [
        
    // 'Garden A',
    // 'Garden B',
    // 'Garden c',
    // 'Garden D',
    //   ];
  
 

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

                if (username == 'admin' && password == 'admin') {
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
            floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
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
    void fetchUsers() async {
    print('fetch started');
    const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    //const url = 'http://rcssoft.in/DocMgmt/api/Location?LocId=0,LocName=';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    setState(() {
      users = jsonDecode(body);
    });
    print('fetch complete');
                //print (users[0]['LocName']);
  }

    Future getAllCategory() async {
    print('fetch started');
    //const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
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

}
