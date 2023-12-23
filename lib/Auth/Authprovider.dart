import 'package:firebase_auth/firebase_auth.dart';

abstract class Authprovider {
  Future<UserCredential?> Register(
      {required String email, required String password});

  Future<UserCredential?> SignIn(
      {required String email, required String password});

  Future<void> SignOut();

  Stream<User?> getuserdata();

  Future<void> SendEmailVerfication();

  Future<void> SendForgetPasswordEmail({required String email});

  Future<UserCredential> SignInWITHGoogle();
  get user;
}
