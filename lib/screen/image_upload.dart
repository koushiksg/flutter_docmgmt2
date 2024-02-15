import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageUploadScreen extends StatefulWidget {
  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<int>? _selectedFile;
  Uint8List? _bytesData;
  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();
      reader.onLoadEnd.listen((event) {
        setState(() {
          _bytesData =
              Base64Decoder().convert(reader.result.toString().split(",").last);
          _selectedFile = _bytesData;
        });
      });
      reader.readAsDataUrl(file);
    });
  }

  Future uploadImage() async {
    var url = Uri.parse("uri");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Text('Lets upload image'),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.pink,
                elevation: 8,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textColor: Colors.white,
                child: Text('Select Photo'),
                onPressed: () {
                  startWebFilePicker();
                },
              ),
              Divider(
                color: Colors.teal,
              ),
              _bytesData != null
                  ? Image.memory(_bytesData!, width: 200, height: 200)
                  : Container(),
              MaterialButton(
                color: Colors.purple,
                elevation: 8,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textColor: Colors.white,
                child: Text('Send File to Server'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
