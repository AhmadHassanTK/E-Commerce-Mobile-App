// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/CloudProvider/CloudServices.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  About({super.key});

  final CloudServices services = CloudServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Your account',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.create_sharp),
                    title: Text('Created'),
                    subtitle: Text(
                        '${FirebaseAuth.instance.currentUser!.metadata.creationTime}',
                        style: TextStyle(color: Colors.green)),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.login_outlined),
                    title: Text('Last sign in'),
                    subtitle: Text(
                        '${FirebaseAuth.instance.currentUser!.metadata.lastSignInTime}',
                        style: TextStyle(color: Colors.green)),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.numbers),
                    title: Text('Age'),
                    subtitle: FutureBuilder(
                        future: services.getuserage(
                            userid: FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('${snapshot.data}',
                                style: TextStyle(color: Colors.green));
                          }
                          return Text('null');
                        }),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.email_outlined),
                    title: Text('Email'),
                    subtitle: Text(
                      '${FirebaseAuth.instance.currentUser!.email}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            )));
  }
}
