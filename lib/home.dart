import 'package:flutter/material.dart';

// [Themelist] インスタンスにおける処理。
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
            const Text('ようこそ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(userId),
          ],
        ),
      ),
    );
  }
}