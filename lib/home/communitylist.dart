import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smi/newcommunity/joincommunity.dart';
import '../newcommunity/addcommunity.dart';
import '../community/home.dart';

class CommunityList extends StatefulWidget {
  const CommunityList({Key? key}) : super(key: key);
  @override
  _CommunityListPage createState() => _CommunityListPage();
}

class _CommunityListPage extends State<CommunityList> {
  final db = FirebaseFirestore.instance;
  List<DocumentSnapshot> documentList = [];

  @override
  void initState() {
    super.initState();
    getListData();
  }

  Future<void> getListData() async {
    final snapshot = await db.collection('communities').get();
    documentList = snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: db.collection('communities').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: documentList.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['name']),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityHome(communityId: document.id, communityName: document['name']),
                                )
                            );
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      );
                    }).toList(),
                  );
                } else {
                  const Text("Start by joining or adding a community!", style: TextStyle(fontSize: 16));
                }
                // データが読込中の場合
                return const Center(
                  child: Text('Loading...'),
                );
              },
            ),
          ),
        ],
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