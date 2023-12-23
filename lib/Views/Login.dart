// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:email_validator/email_validator.dart';
import 'package:flower_app/Auth/Authservices.dart';
import 'package:flower_app/Auth/firebaseAuth.dart';
import 'package:flower_app/Shared/MyTextField.dart';
import 'package:flower_app/Views/ForgetPssword.dart';
import 'package:flower_app/Views/Home.dart';
import 'package:flower_app/Views/Register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  bool buttonpressed = false;
  bool ispassword = true;
  Color iconcolor = Colors.black;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Authservices authservices = Authservices(FirebaseAuthprovider());

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign in',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    validate: (value) {
                      return value != null && !EmailValidator.validate(value)
                          ? 'Enter a valid email'
                          : null;
                    },
                    controller: _email,
                    hintValue: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    isObscureText: false,
                    autofocusflag: true,
                    icon: Icon(Icons.email_outlined),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    validate: (value) {
                      return value!.length < 8
                          ? 'Enter at least 8 charactars'
                          : null;
                    },
                    controller: _password,
                    hintValue: 'Enter your password',
                    textInputType: TextInputType.text,
                    isObscureText: ispassword,
                    autofocusflag: false,
                    icon: ispassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        ispassword = !ispassword;
                      });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          buttonpressed = true;
                        });

                        final user = await authservices.SignIn(
                            email: _email.text, password: _password.text);

                        setState(() {
                          buttonpressed = false;
                        });
                        if (user != null) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (contxt) => Home()),
                              (route) => false);
                        }
                      }
                    },
                    child: buttonpressed
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                            ),
                          ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => ForgetPassword());
                    },
                    child: Text(
                      'Forget your password ?',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Do not have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                              (route) => false);
                        },
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final user =
                                  await authservices.SignInWITHGoogle();
                              print('user is $user');
                              if (!mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (route) => false);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            child: Row(
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  FontAwesomeIcons.googlePlusG,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            child: Row(
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
