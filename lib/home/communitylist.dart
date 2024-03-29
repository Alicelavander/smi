import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smi/newcommunity/joincommunity.dart';

import '../community/communityhome.dart';
import '../newcommunity/createcommunity.dart';

class CommunityList extends StatefulWidget {
  const CommunityList({Key? key}) : super(key: key);

  @override
  _CommunityListPage createState() => _CommunityListPage();
}

class _CommunityListPage extends State<CommunityList> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getListData() async {
    Query query = db
        .collection('user-community-link')
        .where("user", isEqualTo: user?.uid);
    var result = await query.get();
    return Future.wait(result.docs.map((document) {
      return db.collection('communities').doc(document['community']).get();
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
              future: getListData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Start by joining or creating a community.',
                        style: TextStyle(fontSize: 16)),
                  );
                }

                return ListView(
                  children: snapshot.data!.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          document["name"],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommunityHome(communityId: document.id),
                              ));
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
        backgroundColor: const Color(0xFF0073a8),
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
                  ));
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
                  ));
            },
          ),
        ],
      ),
    );
  }
}
