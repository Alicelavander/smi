import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smi/newcommunity/joincommunity.dart';
import '../newcommunity/createcommunity.dart';
import '../community/communityhome.dart';

class CommunityList extends StatefulWidget {
  const CommunityList({Key? key}) : super(key: key);
  @override
  _CommunityListPage createState() => _CommunityListPage();
}

class _CommunityListPage extends State<CommunityList> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  List<DocumentSnapshot> listData = [];

  @override
  void initState() {
    super.initState();
    getListData();
  }

  Future<List<DocumentSnapshot<Object?>>> getListData() async {
    Query query = db.collection('user-community-link').where("user", isEqualTo: user?.uid);
    var result = await query.get();
    result.docs.map((document) async {
      var doc = await db.collection('communities').doc(document['community']).get();
      listData.add(doc);
    });
    return listData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot<Object?>>>(
              future: getListData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: listData.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document.data().toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityHome(communityId: document.id),
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
            label: 'Create',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCommunity(),
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