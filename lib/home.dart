import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'login.dart';

class Home extends StatelessWidget {
  final String userId;
  const Home({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("smi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return const Login();
                }),
              );
            },
          ),
        ],
      ),
      body:Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //_buildAccountInfo(),
            const Text('Hi! Start by posting your identity.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(userId),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        closeManually: false,
        renderOverlay: false,
        // activeForegroundColor: Colors.red,
        // activeBackgroundColor: Colors.blue,
        isOpenOnStart: false,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Add',
            onTap: () => debugPrint('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.person_add),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'Join',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(("Third Child Pressed")))),
            onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
          ),
        ],
      ),
    );
  }
}