import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../login.dart';

class AddCommunity extends StatefulWidget {
  const AddCommunity({Key? key}) : super(key: key);
  @override
  _AddCommunityPage createState() => _AddCommunityPage();
}

class _AddCommunityPage extends State<AddCommunity> {
  String communityName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("コミュニティを新規作成"),
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
                  labelText: "名前"
              ),
                maxLength: 20,  // 入力可能な文字数の制限を超える場合の挙動の制御
                onChanged: (String value) {
                  communityName = value;
                },
              ),
            ),

            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('作成',
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