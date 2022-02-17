import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'AuthenticationError.dart';
import 'signup.dart';
import '../home.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // メールアドレスの入力フォーム
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child:TextFormField(
                  decoration: const InputDecoration(
                      labelText: "email address"
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
                    labelText: "パスワード"
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
                child: const Text('ログイン',
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

      // 画面下にボタンの配置
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                  // ボタンクリック後にアカウント作成用の画面の遷移する。
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => const Signup(),
                      ),
                    );
                  },
                  child: const Text('アカウントを作成する',
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