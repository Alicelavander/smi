import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smi/community/addexperience.dart';

class IdentityDetail extends StatefulWidget {
  final String communityId;
  final String identityId;
  const IdentityDetail({Key? key, required this.communityId, required this.identityId}) : super(key: key);
  @override
  _IdentityDetailPage createState() => _IdentityDetailPage();
}

class _IdentityDetailPage extends State<IdentityDetail> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String experience = "";
  bool _postAnonymous = true;
  
  Future<String> userNameList() async {
    int anonymous = 0;
    List<String> nameList = [];
    await db.collection('communities').doc(widget.communityId).collection('identities').doc(widget.identityId).collection('population').get().then((value) => {
      value.docs.forEach((element) {
        if(element["name"].toString() == "Anonymous"){
          anonymous++;
        } else {
          nameList.add(element["name"]);
          print(element["name"]);
        }
      })
    });
    String names = nameList.toString();
    return "$names, and $anonymous anonymous people";
  }

  Future<String> getCommunityInfo(String info) async {
    DocumentSnapshot doc = await db.collection('communities').doc(widget.communityId).collection('identities').doc(widget.identityId).get();
    return doc[info].toString();
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<String> (
              future: userNameList(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                  child: Text(
                    "Posted by: ${snapshot.data}",
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0.0, 10.0),
              child: SwitchListTile(
                title: const Text('post anonymously?'),
                value: _postAnonymous,
                onChanged: (bool value){
                  setState(() {
                    _postAnonymous = value;
                  });
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
                builder: (context) => AddExperience(communityId: widget.communityId, identityName: widget.identityId),
              )
          );
        },
      )
    );
  }
}