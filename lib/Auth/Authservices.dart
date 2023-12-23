import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/Auth/Authprovider.dart';

class Authservices {
  Authprovider provider;
  Authservices(this.provider);
  Future<UserCredential?> Register(
          {required String email, required String password}) =>
      provider.Register(email: email, password: password);

  Future<UserCredential?> SignIn(
          {required String email, required String password}) =>
      provider.SignIn(email: email, password: password);

  Future<void> SignOut() => provider.SignOut();

  Stream<User?> getuserdata() => provider.getuserdata();

  Future<void> SendEmailVerfication() => provider.SendEmailVerfication();

  Future<void> SendForgetPasswordEmail({required String email}) =>
      provider.SendForgetPasswordEmail(email: email);

  Future<UserCredential> SignInWITHGoogle() => provider.SignInWITHGoogle();

  get user => provider.user;
}
