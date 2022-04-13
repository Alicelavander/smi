import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smi/community/communityhome.dart';
import '../login.dart';
import 'dart:math';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({Key? key}) : super(key: key);

  @override
  _CreateCommunityPage createState() => _CreateCommunityPage();
}

class _CreateCommunityPage extends State<CreateCommunity> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String communityName = "";
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a new community")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                maxLengthEnforcement: MaxLengthEnforcement.none,
                decoration:
                    const InputDecoration(labelText: "Name of the community"),
                maxLength: 30,
                // 入力可能な文字数の制限を超える場合の挙動の制御
                onChanged: (String value) {
                  communityName = value;
                },
              ),
            ),
            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  // サブコレクション内にドキュメント作成
                  await db.collection('communities').add({
                    'name': communityName,
                    'code': getRandomString(7)
                  }).then((DocumentReference newCommunity) => {
                        db.collection('user-community-link').add(
                            {'user': user?.uid, 'community': newCommunity.id}),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommunityHome(communityId: newCommunity.id),
                            ))
                      });
                },
                child: const Text(
                  'Create',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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
