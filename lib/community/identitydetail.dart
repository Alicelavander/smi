import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smi/community/addexperience.dart';

class IdentityDetail extends StatefulWidget {
  final String communityId;
  final String identityId;

  const IdentityDetail(
      {Key? key, required this.communityId, required this.identityId})
      : super(key: key);

  @override
  _IdentityDetailPage createState() => _IdentityDetailPage();
}

class _IdentityDetailPage extends State<IdentityDetail> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> userNameList() async {
    int anonymous = 0;
    List<String> nameList = [];
    await db
        .collection('communities')
        .doc(widget.communityId)
        .collection('identities')
        .doc(widget.identityId)
        .collection('population')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element["name"].toString() == "Anonymous") {
                  anonymous++;
                } else {
                  nameList.add(element["name"]);
                }
              })
            });
    String names = nameList.toString();
    names = names.substring(1, names.length - 1);
    if (names.isEmpty) {
      return "$anonymous anonymous people";
    } else if (anonymous == 0){
      return names;
    } else {
      return "$names, and $anonymous anonymous people";
    }
  }

  Future<String> getCommunityInfo(String info) async {
    DocumentSnapshot doc = await db
        .collection('communities')
        .doc(widget.communityId)
        .collection('identities')
        .doc(widget.identityId)
        .get();
    return doc[info].toString();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsData() async {
    return await db.collection('posts')
        .where("community", isEqualTo: widget.communityId)
        .where("identity", isEqualTo: widget.identityId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder<String>(
            future: getCommunityInfo('name'),
            builder: (context, snapshot) {
              return Text("${snapshot.data}");
            }
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<String>(
                future: userNameList(),
                builder: (context, snapshot) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Posted by: ${snapshot.data}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  );
                }),
            const Padding(padding: EdgeInsets.all(20)),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: getPostsData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.all(10),
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
                                  'written by someone',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 10,
                          margin: const EdgeInsets.fromLTRB(
                            10.0, 5.0, 10.0, 5.0
                          )
                        );
                      }).toList(),
                    );
                  } else {
                    const Center(
                      child: Text('No experiences shared yet.',
                          style: TextStyle(fontSize: 16)),
                    );
                  }
                  // データが読込中の場合
                  return const Center(
                    child: Text('Loading...'),
                  );
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddExperience(
                      communityId: widget.communityId,
                      identityId: widget.identityId),
                ));
          },
          label: const Text('share experience'),
          backgroundColor: const Color(0xFF0073a8),
        ));
  }
}
