import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../login.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      /*
    //Web setup
    options: const FirebaseOptions(
      apiKey: 'AIzaSyB34IqDrVeynPFGjo1F68f_eCb48sTLt70',
      appId: '1:208019141585:web:709c384e998d9a798a26f0',
      messagingSenderId: '208019141585',
      projectId: 'smi-technovation',
      authDomain: 'smi-technovation.firebaseapp.com',
      storageBucket: 'smi-technovation.appspot.com',
      measurementId: 'G-GCRQVRZ9BX',
    ),
     */
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smi',
      home: _CheckLogin(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF0073a8),
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0
        ),
        primaryColor: const Color(0xFF0073a8)
      ),
    );
  }
}

class _CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user?.uid != null) {
      return const Home(pageIndex: 0);
    } else {
      return const Login();
    }
  }
}
