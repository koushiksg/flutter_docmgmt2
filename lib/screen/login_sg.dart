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
  List<dynamic> categoryItemlist = [];
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
                 print(dropdownvalue);
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

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }
}
