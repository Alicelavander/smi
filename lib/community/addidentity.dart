import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smi/community/communityhome.dart';

class AddIdentity extends StatefulWidget {
  final String communityId;
  const AddIdentity({Key? key, required this.communityId}) : super(key: key);
  @override
  _AddIdentityPage createState() => _AddIdentityPage();
}

class _AddIdentityPage extends State<AddIdentity> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String identityName = "";

  Future<void> addIdentity() async {
    var docRef = db.collection('communities').doc(widget.communityId).collection('identities').doc(identityName);

    await docRef.get().then((doc) => (){
      if (doc.exists) {
        docRef.update({"population": doc['population']+1});
      } else {
        docRef.set({"population": 1});
      }
    }).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityHome(communityId: widget.communityId),
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your identity")
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:  const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child:TextFormField(
                maxLengthEnforcement: MaxLengthEnforcement.none, decoration: const InputDecoration(
                  labelText: "Enter your identity"
              ),
                onChanged: (String value) {
                  identityName = value;
                },
              ),
            ),

            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                onPressed: addIdentity,
                child: const Text('Add',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, //ボタンの背景色
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}