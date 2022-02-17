import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'AuthenticationError.dart';
import '../home.dart';

// アカウント登録ページ
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  String newEmail = "";  // 入力されたメールアドレス
  String newPassword = "";  // 入力されたパスワード
  String infoText = "";  // 登録に関する情報を表示
  bool pswdOK = false;  // パスワードが有効な文字数を満たしているかどうか

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
            const Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0),
                child:Text('新規アカウントの作成',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ),

            // メールアドレスの入力フォーム
            Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child:TextFormField(
                  decoration: const InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    newEmail = value;
                  },
                )
            ),

            // パスワードの入力フォーム
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child:TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.none, decoration: const InputDecoration(
                      labelText: "パスワード（8～20文字）"
                  ),
                  obscureText: true,  // パスワードが見えないようRにする
                  maxLength: 20,  // 入力可能な文字数の制限を超える場合の挙動の制御
                  onChanged: (String value) {
                    if(value.length >= 8){
                      newPassword= value;
                      pswdOK = true;
                    }else{
                      pswdOK = false;
                    }
                  }
              ),
            ),

            // 登録失敗時のエラーメッセージ
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
                  if (pswdOK){
                    try {
                      // メール/パスワードでユーザー登録
                      UserCredential result = await auth.createUserWithEmailAndPassword(
                        email: newEmail,
                        password: newPassword,
                      );

                      // 登録成功
                      // 登録したユーザー情報
                      User user = result.user!;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(userId: user.uid),
                          )
                      );

                    } catch (e) {
                      // 登録に失敗した場合
                      setState(() {
                        infoText = authError.registerErrorMsg(e.toString());
                      });
                    }
                  }else{
                    setState(() {
                      infoText = 'パスワードは8文字以上です。';
                    });
                  }
                },
                child: const Text('登録',
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
