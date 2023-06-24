import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}):super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest API Called'),
      ),
      
      body: 
      
      ListView.builder(

        itemCount: users.length,
        itemBuilder: (context,index){
          final user = users[index] ;
          final int srlno = user['SrlNo'];
          final locname= user['ItemName'];
          final brandname = user['BrandName'];
        return ListTile(
          leading: CircleAvatar(
           child: Text('$srlno'),
          ),
          title: Text(locname),
          subtitle: Text(brandname),
        );
      }
      
      ),
      floatingActionButton: FloatingActionButton(onPressed: fetchUsers,),
    );
    
  }

  void fetchUsers() async{
print('fetch started');
    //const url = 'http://rcssoft.in/DocMgmt/api/Location/?LocId=0&LocName=';
    const url = 'http://rcssoft.in/DocMgmt/api/Item?ItNo=1000';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    setState((){
    users = jsonDecode(body);
    });
print('fetch complete');

  }
}