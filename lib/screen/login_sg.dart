import 'package:flutter/material.dart';
import 'enlist_sg.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String? _selectedDocumentType;
  final List<String> _garden_name = [
    'Garden A',
    'Garden B',
    'Garden c',
    'Garden D'
  ];
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
            DropdownButtonFormField<String>(
              value: _selectedDocumentType,
              onChanged: (newValue) {
                setState(() {
                  _selectedDocumentType = newValue;
                });
              },
              items: _garden_name.map((documentType) {
                return DropdownMenuItem<String>(
                  value: documentType,
                  child: Text(documentType),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Garden Name',
              ),
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
}
