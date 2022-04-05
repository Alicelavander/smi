import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../community/communityhome.dart';
import '../login.dart';

class JoinCommunity extends StatefulWidget {
  const JoinCommunity({Key? key}) : super(key: key);
  @override
  _JoinCommunityPage createState() => _JoinCommunityPage();
}

class _JoinCommunityPage extends State<JoinCommunity> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String communityCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join a community"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return const Login();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:  const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child:TextFormField(
                maxLengthEnforcement: MaxLengthEnforcement.none, decoration: const InputDecoration(
                  labelText: "Invitation code"
              ),
                maxLength: 20,  // 入力可能な文字数の制限を超える場合の挙動の制御
                onChanged: (String value) {
                  communityCode = value;
                },
              ),
            ),

            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  Query query = db.collection('communities').where("code", isEqualTo: communityCode);
                  var result = await query.get();

                  if(result.docs.isEmpty){
                    ///Community doesn't exist!
                  } else {
                    ///先に確認てきなん入れたい
                    db.collection('user-community-link').add({
                      'user': user?.uid,
                      'community': result.docs.single.id
                    }).then((value) => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommunityHome(communityId: result.docs.single.id),
                          )
                      )
                    });
                  }
                },
                child: const Text('Join',
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