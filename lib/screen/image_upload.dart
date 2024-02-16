import 'dart:typed_data';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
class ImageUploadScreen extends StatefulWidget {
  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<int>? _selectedFile;
  Uint8List? _bytesData;
//  String selectfile;
//  Uint8List selectedImageInBytes;

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
      final mlen = files.length;
      for (var i = 0; i < mlen; i++) {
        print(files[i].name);
      }
    });
  }

//_selectFile(bool imageFrom) async {
//  FilePickerResult fileResult = await FilePicker.platform.pickFiles();
//  if (fileResult != null) {
//    setState(() {
//      selectfile = fileResult.files.first.name;
//
//    });
//  }
//}
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
              //_bytesData != null
              //    ? Image.memory(_bytesData!, width: 200, height: 200)
              //    :
                  //: Container(),
                 //_bytesData != null
                  //?
                  _bytesData != null
                  ? CarouselSlider(
  options: CarouselOptions(height: 400.0),
  items:_selectedFile!.map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.amber
          ),
//child: Image.memory(_bytesData!, width: 200, height: 200)
child: Text('text $i', style: TextStyle(fontSize: 16.0),)
        );
      },
    );
  }).toList(),
):
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
