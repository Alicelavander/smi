//Firebase Authentication利用時の日本語エラーメッセージ
//CURRENTLY NOT WORKING AT ALL
class AuthenticationError {

  // ログイン時の日本語エラーメッセージ
  String loginErrorMsg(String errorCode){
    String errorMsg;
    switch (errorCode) {
      case 'invalid-email':
        errorMsg = '有効なメールアドレスを入力してください。';
        break;

      case 'wrong-password':
        errorMsg = 'メールアドレスかパスワードが間違っています。';
        break;

      case 'user-disabled':
        errorMsg = 'ユーザーが無効化されています。';
        break;

      case 'too-many-requests':
        errorMsg = 'smiの門番はちょっと疲れちゃったみたい。ちょっとまってあげてね。';
        break;

      default:
        errorMsg = errorCode;
        break;
    }
    return errorMsg;
  }


  // アカウント登録時の日本語エラーメッセージ
  String registerErrorMsg(String errorCode){
    String errorMsg;
    switch (errorCode) {
      case 'email-already-in-use':
        errorMsg = 'そのメールアドレスは既に使用されています。別のメールアドレスをお試しください。';
        break;

      case 'invalid-email':
        errorMsg = '有効なメールアドレスを入力してください。';
        break;

      case 'too-many-requests':
        errorMsg = 'smiの門番はちょっと疲れちゃったみたい。ちょっとまってあげてね。';
        break;

      default:
        errorMsg = errorCode;
        break;
    }
    return errorMsg;
  }

}