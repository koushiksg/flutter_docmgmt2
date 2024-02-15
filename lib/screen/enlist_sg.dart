import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';

class DocumentUploadForm extends StatefulWidget {
  const DocumentUploadForm({super.key});

  @override
  _DocumentUploadFormState createState() => _DocumentUploadFormState();
}

class _DocumentUploadFormState extends State<DocumentUploadForm> {
  final List<File> _imageFiles = [];
  final picker = ImagePicker();
  String? _selectedDocumentType;
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  var dropdownvalue;
  List<dynamic> doctypelist = [];

  final List<String> _documentTypes = [
    'Passport',
    'ID Card',
    'Driving License',
    'Other'
  ];

  void _pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFiles.add(File(pickedFile.path));
      }
    });
  }

  void _pickImageFromGallery() async {
    final pickedFiles = await picker.getMultiImage(
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    setState(() {
      if (pickedFiles != null) {
        _imageFiles
            .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      }
    });
  }

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

  void _refreshForm() {
    setState(() {
      _selectedDocumentType = null;
      _documentNumberController.clear();
      _remarksController.clear();
      _imageFiles.clear();
    });
  }

  void _submitForm() {
    if (_selectedDocumentType != null) {
      print('Selected Document Type: $_selectedDocumentType');
    }

    if (_documentNumberController.text.isNotEmpty) {
      print('Document Number: ${_documentNumberController.text}');
    }

    if (_remarksController.text.isNotEmpty) {
      print('Remarks: ${_remarksController.text}');
    }

    if (_imageFiles.isNotEmpty) {
      for (var i = 0; i < _imageFiles.length; i++) {
        print('Image ${i + 1} Path: ${_imageFiles[i].path}');
      }
    }

    // Add your logic here to handle the selected document type, document number, remarks, and the uploaded images

    _refreshForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedDocumentType,
              onChanged: (newValue) {
                setState(() {
                  _selectedDocumentType = newValue;
                });
              },
              items: doctypelist.map((documentType) {
                return DropdownMenuItem<String>(
                  value: documentType['DocTypeId'].toString(),
                  child: Text(documentType['DocTypeName'].toString()),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Document Type',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _documentNumberController,
              decoration: const InputDecoration(
                labelText: 'Document Number',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _remarksController,
              decoration: const InputDecoration(
                labelText: 'Remarks',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
onPressed: () {
                  startWebFilePicker();
                },
                              child: const Text('Upload Photo'),
            ),
                          _bytesData != null
                  ? Image.memory(_bytesData!, width: 200, height: 200)
                  : Container(),

            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _refreshForm,
              child: const Text('Refresh Form'),
            ),
            const SizedBox(height: 16.0),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _imageFiles.length,
              //itemCount: _selectedFile.length,

              itemBuilder: (BuildContext context, int index) {
                //return Image.file(_imageFiles[index]);
                return Image.network("https://picsum.photos/250?image=9");
                //return Image.network("E://DocMgmt/Img/Img1.jpg");
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDocType();
  }

  Future getDocType() async {
    const url =
        'http://rcssoft.in/DocMgmt/api/DocType/?DocTypeId=0&DocTypeName=';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    if (jsonDecode(body) != null) {
      setState(() {
        doctypelist = jsonDecode(body);
      });
    } else {
      setState(() {
        doctypelist.clear();
      });
    }
  }
}
