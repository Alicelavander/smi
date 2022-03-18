import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityHome extends StatefulWidget {
  final String communityId;
  final String communityName;
  const CommunityHome({Key? key, required this.communityId, required this.communityName, userId}) : super(key: key);

  @override
  _CommunityHomePage createState() => _CommunityHomePage();
}

class _CommunityHomePage extends State<CommunityHome> {
  final db = FirebaseFirestore.instance;
  List<DocumentSnapshot>? identityList;

  @override
  void initState() {
    super.initState();
    getListData();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListData() async {
    final snapshot = await db.collection('communities').doc(widget.communityId).collection('identities').get();
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("${widget.communityName}'s identity board")
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: getListData(),
                builder: (context, snapshot) {
                  print("hasData:${snapshot.hasData}");
                  print("data:${snapshot.data}");
                  print("isEmpty:${snapshot.data?.docs.isEmpty}");
                  print("isNotEmpty:${snapshot.data!.docs.isNotEmpty}");
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                            children: snapshot.data?.docs.map((document) =>
                                Card(
                                  child: ListTile(
                                    title: Text(document['name']),
                                    onTap: () {},
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 10,
                                  margin: const EdgeInsets.fromLTRB(
                                      10.0, 5.0, 10.0, 5.0),
                                )).toList() ?? [Text('no items')]),
                      );
                    } else {
                      return const Text("Be the first to add an identity!",
                          style: TextStyle(fontSize: 16));
                    }
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
      ),
    );
  }
}