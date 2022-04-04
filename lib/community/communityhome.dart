import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smi/home/communitylist.dart';
import 'package:smi/home/home.dart';
import 'addidentity.dart';

class CommunityHome extends StatefulWidget {
  final String communityId;
  const CommunityHome({Key? key, required this.communityId}) : super(key: key);

  @override
  _CommunityHomePage createState() => _CommunityHomePage();
}

class _CommunityHomePage extends State<CommunityHome> {
  final db = FirebaseFirestore.instance;
  List<DocumentSnapshot>? identityList;

  @override
  void initState() {
    super.initState();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListData() async {
    final snapshot = await db.collection('communities').doc(widget.communityId).collection('identities').get();
    return snapshot;
  }

  Future<String> getCommunityName() async {
    DocumentSnapshot doc = await db.collection('communities').doc(widget.communityId).get();
    return doc['name'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FutureBuilder<String>(
          future: getCommunityName(),
          builder: (context, snapshot) {
            return Text("${snapshot.data}'s identity board");
          }
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(pageIndex: 1),
                  )
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: getListData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                            children: snapshot.data!.docs.map((document) =>
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
                                )).toList()),
                      );
                    } else {
                      return const Center(
                        child: Text("Be the first to add an identity!"),
                      );
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddIdentity(communityId: widget.communityId),
              )
          );
        },
      )
    );
  }
}