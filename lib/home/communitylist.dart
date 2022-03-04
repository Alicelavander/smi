import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smi/newcommunity/joincommunity.dart';
import '../newcommunity/addcommunity.dart';

class CommunityList extends StatefulWidget {
  const CommunityList({Key? key}) : super(key: key);
  @override
  _CommunityListPage createState() => _CommunityListPage();
}

class _CommunityListPage extends State<CommunityList> {
  List<DocumentSnapshot> documentList = [];

  @override
  void initState() {
    super.initState();
    getListData();
  }

  Future<void> getListData() async {
    final snapshot = await FirebaseFirestore.instance.collection('communities').get();
    documentList = snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            //Communityが0のときのみ↓の文を表示させる
            if (documentList.isEmpty) const Text("Start by joining or adding a community!", style: TextStyle(fontSize: 16)),

            Column(
              children: documentList.map((DocumentSnapshot document) {
                return Card(
                  child: ListTile(
                    title: Text(document.id),
                    onTap: () {},
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                );
              }).toList(),
            ),
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCommunity(),
                  )
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.person_add),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'Join',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JoinCommunity(),
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}