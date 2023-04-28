abstract class AuthProviderError {}

class AuthProviderIncorectLoginDataError {}

class AuthApiProvider {
  Future<String> login(String login, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final isSucces = login == 'admin' && password == '123456';
    if (isSucces) {
      return 'dsa9d9sadk32kk2k93p12312k';
    } else {
      throw AuthProviderIncorectLoginDataError();
    }
  }
}
