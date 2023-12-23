// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/Auth/Authprovider.dart';
import 'package:flower_app/CloudProvider/CloudServices.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthprovider implements Authprovider {
  final CloudServices cloudServices = CloudServices();
  @override
  Stream<User?> getuserdata() {
    return FirebaseAuth.instance.authStateChanges();
  }

  @override
  get user {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Future<UserCredential?> Register(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Erorr',
        e.code,
        snackPosition: SnackPosition.BOTTOM,
        borderColor: Colors.green,
        colorText: Colors.white,
      );
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  @override
  Future<UserCredential?> SignIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  @override
  Future<void> SignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> SendEmailVerfication() async {
    try {
      final userisverfied = FirebaseAuth.instance.currentUser!.emailVerified;
      final user = FirebaseAuth.instance.currentUser;

      if (!userisverfied) {
        await user!.sendEmailVerification();
      }
    } catch (e) {
      throw FirebaseAuthException;
    }
  }

  @override
  Future<void> SendForgetPasswordEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw FirebaseAuthException;
    }
  }

  @override
  Future<UserCredential> SignInWITHGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final user = await FirebaseAuth.instance.signInWithCredential(credential);

      await cloudServices.cloudAdduser(
        username: user.user!.displayName!,
        age: 'null',
        email: user.user!.email!,
        password: 'null',
      );

      return user;
    } catch (e) {
      throw FirebaseAuthException;
    }
  }
}
