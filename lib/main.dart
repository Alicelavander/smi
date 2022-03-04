import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../login.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smi',
      home: _CheckLogin(),
    );
  }
}

class _CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if(user?.uid != null){
      return Home(userId: user!.uid,);
    } else {
      return const Login();
    }
  }
}