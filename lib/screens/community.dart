import 'package:flutter/material.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';
import '../Componnent/Navigation.dart';

void main() {
  runApp(const MaterialApp(
    home: Community(),
    debugShowCheckedModeBanner: false, // Set this to false
  ));
}

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _MoreState();
}

class _MoreState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("THIS IS THE COMMUNITY PAGE"),
        backgroundColor: Colors.grey[800],
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          // scrolable content goes from here
          Container(
            height: 200,
            color: Colors.yellow[800],
            child: Center(child: Text("FIRST CONTENT")),
          ),

          Container(
            height: 200,
            color: Colors.blue[800],
            child: Center(child: Text("SECONFD CONTENT HERE")),
          ),

          Container(
            height: 200,
            color: Colors.red[800],
            child: Center(child: Text("THIRD CONTENT HERE")),
          ),

          Container(
            height: 200,
            color: Colors.indigo[200],
            child: Center(child: Text("fifth CONTENT goes here")),
          ),

          // Any other content can go here in a scrolable container
        ]),
      ),

//End of bottom navigation bar
    );
  }
}
