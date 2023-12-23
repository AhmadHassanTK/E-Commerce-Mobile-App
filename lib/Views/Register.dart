// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:email_validator/email_validator.dart';
import 'package:flower_app/Auth/Authservices.dart';
import 'package:flower_app/Auth/firebaseAuth.dart';
import 'package:flower_app/CloudProvider/CloudServices.dart';
import 'package:flower_app/Shared/MyTextField.dart';
import 'package:flower_app/Views/EmailVerfication.dart';
import 'package:flower_app/Views/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key = GlobalKey<FormState>();
  bool ispassword = true;
  bool registerpressed = false;
  bool passwordsuccess = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final CloudServices cloudServices = CloudServices();
  final Authservices authservices = Authservices(FirebaseAuthprovider());

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _age.dispose();
    _username.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: _username,
                    autofocusflag: false,
                    hintValue: 'Enter your username',
                    textInputType: TextInputType.emailAddress,
                    icon: Icon(Icons.person),
                    isObscureText: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: _age,
                    autofocusflag: true,
                    hintValue: 'Enter your age',
                    isObscureText: false,
                    textInputType: TextInputType.name,
                    icon: Icon(Icons.numbers),
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
                    autofocusflag: false,
                    hintValue: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    icon: Icon(Icons.email_outlined),
                    isObscureText: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    validate: (value) {
                      return passwordsuccess ? null : 'Not Valid';
                    },
                    controller: _password,
                    hintValue: 'Enter your password',
                    textInputType: TextInputType.text,
                    isObscureText: ispassword,
                    autofocusflag: false,
                    icon: Icon(
                        ispassword ? Icons.visibility : Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        ispassword = !ispassword;
                      });
                    },
                  ),
                  FlutterPwValidator(
                    controller: _password,
                    minLength: 8,
                    uppercaseCharCount: 2,
                    numericCharCount: 3,
                    specialCharCount: 1,
                    //normalCharCount: 3,
                    width: 400,
                    height: 150,
                    onSuccess: () {
                      setState(() {
                        passwordsuccess = true;
                      });
                      print("MATCHED");
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password is matched")));
                    },
                    onFail: () {
                      setState(() {
                        passwordsuccess = false;
                      });
                      print("NOT MATCHED");
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          registerpressed = true;
                        });
                        final user = await authservices.Register(
                            email: _email.text, password: _password.text);

                        await cloudServices.cloudAdduser(
                            username: _username.text,
                            age: _age.text,
                            email: _email.text,
                            password: _password.text);

                        if (!mounted) return;
                        if (user != null) {
                          await authservices.SendEmailVerfication();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => EmailVerfication()),
                              (route) => false);
                        }

                        setState(() {
                          registerpressed = false;
                        });
                      }
                    },
                    child: registerpressed
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Do you already have an account ?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) => false);
                        },
                        child: Text('Sign in'),
                      ),
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
