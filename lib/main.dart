// https://github.com/OverTheBeez/todo_list_final_project
// https://console.firebase.google.com/u/0/project/to-do-project-final/overview

import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation.dart';

// Sample code from https://github.com/pythonhubpy/YouTube/blob/Firebae-CRUD-Part-1/lib/main.dart#L19
// video https://www.youtube.com/watch?v=SmmCMDSj8ZU&list=PLtr8DfMFkiJu0lr1OKTDaoj44g-GGnFsn&index=10&t=291s

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AAAAeml7VhE:APA91bGaUdZxp7gLeHUmEWz4irQRPGYRVE5_cT_u_0SRSHdeQ_ykrt2I4R-KT4vejEjADU9zfKIrZtHf-dRqOcnIfd9sIcWyXD4umOKY1OANpNhLc5iJYviucvqZEeIz8vjTonrY9TCM ",
      appId: "com.example.todo_list_final_project",
      messagingSenderId: "525755700753",
      projectId: "to-do-project-final",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List Final Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseDemo(),
    );
  }

}

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseDemoState createState() => _FirebaseDemoState();
}

class _FirebaseDemoState extends State<FirebaseDemo> {
  final TextEditingController _newItemTextField = TextEditingController();
  final CollectionReference itemCollectionDB = FirebaseFirestore.instance.collection('ITEMS');
  List<String> itemList = [];
  final int _selectedIndex = 0;

  Widget nameTextFieldWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.7,
      child: TextField(
        controller: _newItemTextField,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Task:",
          hintStyle: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }

  Widget addButtonWidget() {
    return SizedBox(
      child: ElevatedButton(
          onPressed: () async {
            //setState(() {
            //itemList.add(_newItemTextField.text);
            //_newItemTextField.clear();
            await itemCollectionDB.add({'item_name': _newItemTextField.text}).then((value) => _newItemTextField.clear());
            //});
          },
          child: Text(
            'Add Task',
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  Widget itemInputWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        nameTextFieldWidget(),
        SizedBox(width: 10,),
        addButtonWidget(),
      ],
    );
  }

  Widget itemTileWidget(snapshot, position) {
    return ListTile(
      leading: Icon(Icons.check_box),
      title: Text(snapshot.data.docs[position]['item_name']),
      onTap: () {
        setState(() {
          print("You tapped at postion =  $position");
          String itemId = snapshot.data.docs[position].id;
          itemCollectionDB.doc(itemId).delete();
        });
      },
    );
  }

  Widget itemListWidget() {
    return Expanded(
        child:
        StreamBuilder(stream: itemCollectionDB.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                        child: itemTileWidget(snapshot,position)
                    );
                  }
              );
            })
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      var _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile Device Programming Final Project"),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'To Do List Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.accessibility_new_rounded),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
            ),
            ListTile(
              leading: Icon(Icons.add_to_drive),
              title: Text('Sync'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),


      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            itemInputWidget(),
            SizedBox(height: 40,),
            itemListWidget(),
          ],
        ),
      ),
    );
  }

}