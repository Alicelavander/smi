import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smi/community/communityhome.dart';
import 'package:smi/community/identitydetail.dart';

class AddExperience extends StatefulWidget {
  final String communityId;
  final String identityId;

  const AddExperience(
      {Key? key, required this.communityId, required this.identityId})
      : super(key: key);

  @override
  _AddExperiencePage createState() => _AddExperiencePage();
}

class _AddExperiencePage extends State<AddExperience> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String experience = "";
  bool _postAnonymous = true;

  Future<void> addExperience() async {
    CollectionReference collection = db
        .collection('communities')
        .doc(widget.communityId)
        .collection('identities');
    Query query = collection.where("name", isEqualTo: widget.identityId);
    User? user = FirebaseAuth.instance.currentUser;

    var result = await query.get();
    db.collection('posts').add({
      'experience': experience,
      'community': widget.communityId,
      'identity': widget.identityId,
    }).then((newDocument) => {
          if (_postAnonymous)
            {
              collection.doc(newDocument.id).collection('population').add({
                'author': 'Anonymous',
              })
            }
          else
            {
              collection.doc(newDocument.id).collection('population').add({
                'author': user?.displayName,
              })
            }
        });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentityDetail(communityId: widget.communityId, identityId: widget.identityId),
        ));
  }

  Future<String> getCommunityName() async {
    DocumentSnapshot doc = await db
        .collection('communities')
        .doc(widget.communityId)
        .collection('identities')
        .doc(widget.identityId)
        .get();
    return doc['name'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share your experience")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<String>(
                future: getCommunityName(),
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 50),
                      child: Text(
                        'Identity: ${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      )
                  );
                }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextField(
                maxLengthEnforcement: MaxLengthEnforcement.none,
                decoration:
                    const InputDecoration(labelText: "Write your experience"),
                onChanged: (String value) {
                  experience = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0.0, 10.0),
              child: SwitchListTile(
                title: const Text('post anonymously?'),
                value: _postAnonymous,
                onChanged: (bool value) {
                  setState(() {
                    _postAnonymous = value;
                  });
                },
              ),
            ),
            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                onPressed: addExperience,
                child: const Text(
                  'Add',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF0073a8), //ボタンの背景色
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
