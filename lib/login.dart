import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'AuthenticationError.dart';
import 'signup.dart';
import 'home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<Login> {

  String loginEmail = "";  // 入力されたメールアドレス
  String loginPassword = "";  // 入力されたパスワード
  String infoText = "";  // ログインに関する情報を表示

  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  // エラーメッセージを日本語化するためのクラス
  final authError = AuthenticationError();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                child:Text("Welcome to smi!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ),

            // メールアドレスの入力フォーム
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child:TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Email address"
                  ),
                  onChanged: (String value) {
                    loginEmail = value;
                  },
                )
            ),

            // パスワードの入力フォーム
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child:TextFormField(
                maxLengthEnforcement: MaxLengthEnforcement.none, decoration: const InputDecoration(
                    labelText: "Password"
                ),
                obscureText: true,  // パスワードが見えないようRにする
                maxLength: 20,  // 入力可能な文字数の制限を超える場合の挙動の制御
                onChanged: (String value) {
                  loginPassword= value;
                },
              ),
            ),

            // ログイン失敗時のエラーメッセージ
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
              child:Text(infoText,
                style: const TextStyle(color: Colors.red),),
            ),

            //ログインボタン
            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザー登録
                    UserCredential result = await auth.signInWithEmailAndPassword(
                      email: loginEmail,
                      password: loginPassword,
                    );

                    // ログイン成功
                    // ログインユーザーのIDを取得
                    User user = result.user!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(userId: user.uid),
                        )
                    );

                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = authError.loginErrorMsg(e.toString());
                    });
                  }
                },
                child: const Text('Login',
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

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("or"),
            ),

            //Googleでログインのボタン
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
                  GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                  AuthCredential credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );
                  try {
                    UserCredential result = await auth.signInWithCredential(credential);
                    User user = result.user!;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(userId: user.uid,),
                        )
                    );

                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print(e.toString());
                  }
                }
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
      ),

      // 画面下にボタンの配置
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            const Text("Not signed up yet? Then:"),
            Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child:ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                // ボタンクリック後に新規作成用の画面の遷移する。
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => const Signup(),
                    ),
                  );
                },
                child: const Text('Create a new account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[50], //ボタンの背景色
                ),
              ),
            ),
          ),
        ]),
    );
  }
}