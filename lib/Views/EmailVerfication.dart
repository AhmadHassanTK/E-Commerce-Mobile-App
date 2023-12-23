// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/Auth/Authservices.dart';
import 'package:flower_app/Auth/firebaseAuth.dart';
import 'package:flower_app/Views/Home.dart';
import 'package:flutter/material.dart';

class EmailVerfication extends StatefulWidget {
  EmailVerfication({super.key});

  @override
  State<EmailVerfication> createState() => _EmailVerficationState();
}

class _EmailVerficationState extends State<EmailVerfication> {
  final Authservices services = Authservices(FirebaseAuthprovider());
  Timer? timer;
  bool isverified = FirebaseAuth.instance.currentUser!.emailVerified;

  @override
  void initState() {
    if (!isverified) {
      timer = Timer.periodic(Duration(seconds: 10), (timer) async {
        await FirebaseAuth.instance.currentUser!.reload();

        setState(() {
          isverified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (isverified) {
          timer.cancel();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isverified
        ? Home()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Email Verfication',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A verfication email has been sent to your email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await services.SendEmailVerfication();
                      },
                      child: Text(
                        'Resend Email',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: Text('Cancel'),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
