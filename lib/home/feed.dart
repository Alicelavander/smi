import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smi/community/identitydetail.dart';

import '../community/communityhome.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedPage createState() => _FeedPage();
}

class _FeedPage extends State<Feed> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  Future<List<QuerySnapshot<Map<String, dynamic>>>> getPostsData() async {
    Query query = db.collection('user-community-link').where(
        "user", isEqualTo: user?.uid);
    var result = await query.get();
    return Future.wait(result.docs.map((document) {
      return db.collection('posts')
          .where("community", isEqualTo: document["community"])
          .get();
    }));
  }

  Future<String> communityName(String communityId) async {
    var snapshot = await db.collection('communities').doc(communityId).get();
    return 'from ${snapshot['name']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
                future: getPostsData(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    // データが読込中の場合
                    return const Center(
                      child: Text('Loading...'),
                    );
                  }

                  if (snapshot.data!.where((document) =>
                  document.docs.isNotEmpty).isEmpty) {
                    return const Center(
                      child: Text('No experiences shared yet!',
                          style: TextStyle(fontSize: 16)),
                    );
                  }

                  List<Card> cards = [];
                  for (var element in snapshot.data!) {
                    for(var document in element.docs){
                      cards.add(
                          Card(
                            child: InkWell(
                              child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document['experience'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        'from ${document['communityName']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10)
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IdentityDetail(
                                          communityId: document["community"], identityId: document["identity"]
                                      ),
                                    )
                                );
                              },
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 10,
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 5.0, 10.0, 5.0
                            ),
                          )
                      );
                    }
                  }
                  return ListView(children: cards);
                },
              ),
            )
          ]
      ),
    );
  }
}