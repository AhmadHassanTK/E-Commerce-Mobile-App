// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:email_validator/email_validator.dart';
import 'package:flower_app/Auth/Authservices.dart';
import 'package:flower_app/Auth/firebaseAuth.dart';
import 'package:flower_app/Shared/MyTextField.dart';
import 'package:flower_app/Views/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _email = TextEditingController();
  final Authservices services = Authservices(FirebaseAuthprovider());
  final _key = GlobalKey<FormState>();
  bool buttonpressed = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter your email to rest your password',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                MyTextField(
                  validate: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? 'Enter a valid email'
                        : null;
                  },
                  controller: _email,
                  autofocusflag: true,
                  hintValue: 'Enter your email here',
                  textInputType: TextInputType.emailAddress,
                  isObscureText: false,
                  icon: Icon(Icons.email_outlined),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      setState(() {
                        buttonpressed = !buttonpressed;
                      });
                      await services.SendForgetPasswordEmail(
                          email: _email.text);
                      if (!mounted) return;
                      setState(() {
                        buttonpressed = !buttonpressed;
                      });
                      Get.to(() => Login());
                    }
                  },
                  child: buttonpressed
                      ? CircularProgressIndicator()
                      : Text(
                          'Reset password',
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
