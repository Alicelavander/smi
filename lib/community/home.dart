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
  List<DocumentSnapshot> identityList = [];

  @override
  void initState() {
    super.initState();
    getListData();
  }

  Future<void> getListData() async {
    final snapshot = await db.collection('communities').doc(widget.communityId).collection('identities').get();
    identityList = snapshot.docs;
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
            //list identitites
          ],
        ),
      ),
    );
  }
}