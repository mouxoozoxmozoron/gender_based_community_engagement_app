import 'package:flutter/material.dart';
import '../Componnent/Navigation.dart';


void main() {
  runApp(const MaterialApp(
    home: More(),
    debugShowCheckedModeBanner: false, // Set this to false
  ));
}

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  //TRACKING CURRENT PAGE INDEX
  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text("THIS IS THE MORE PAGE"),
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

//IMPORTING THE NAVIGATION BAR
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex:
            0, // Default value since the More page doesn't track current index
        onTap: (index) {
          if (index == 0) {
            // Navigate back to the Home page
            Navigator.pop(
                context); // Pop the current page to return to the previous page
          }
        },
      ),

//End of bottom navigation bar
    );
  }
}
