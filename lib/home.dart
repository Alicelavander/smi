import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String userId;
  const Home({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //_buildAccountInfo(),
            const Text('ようこそ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(userId),
          ],
        ),
      ),
    );
  }
}