// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/CloudProvider/CloudServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatelessWidget {
  CheckOut({super.key});
  final CloudServices cloudservices = CloudServices();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Checkout',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          actions: [
            Stack(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(10),
                    color: Colors.white60,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Consumer<CloudServices>(
                      builder: (context, value, child) {
                        return FutureBuilder(
                          future: value.datalength(
                              userid: FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data}',
                                style: TextStyle(color: Colors.black),
                              );
                            }
                            return Text('0');
                          },
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Consumer<CloudServices>(
                builder: (context, value, child) {
                  return FutureBuilder(
                      future: value.allprice(
                          userid: FirebaseAuth.instance.currentUser!.uid),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            '\$ ${snapshot.data}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return Text('0');
                        }
                      });
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: cloudservices.alldata(
                owneruserid: FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        snapshot.data!.elementAt(index).path)),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await cloudservices.clouddelete(
                                        documentid: snapshot.data!
                                            .elementAt(index)
                                            .documentid!);
                                  },
                                  icon: Icon(Icons.delete_outlined),
                                ),
                                title: Text(
                                    '${snapshot.data!.elementAt(index).name}'),
                                subtitle: Text(
                                    '\$${snapshot.data!.elementAt(index).price}  ${snapshot.data!.elementAt(index).location}'),
                              ),
                            );
                          },
                        ),
                      ),
                      FutureBuilder(
                        future: cloudservices.allprice(
                            userid: FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () {},
                                child: Text(
                                  'Pay \$${snapshot.data}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
