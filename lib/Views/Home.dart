// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, unnecessary_brace_in_string_interps

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/Auth/Authservices.dart';
import 'package:flower_app/Auth/firebaseAuth.dart';
import 'package:flower_app/CloudProvider/CloudServices.dart';
import 'package:flower_app/Constants/constants.dart';
import 'package:flower_app/Views/About.dart';
import 'package:flower_app/Views/CheckOut.dart';
import 'package:flower_app/Views/Details.dart';
import 'package:flower_app/Views/Login.dart';
import 'package:flower_app/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> items = [];
  final CloudServices cloudservices = CloudServices();
  final Authservices authservices = Authservices(FirebaseAuthprovider());
  void getItems() {
    items = Item.getItems();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    getItems();
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: FutureBuilder(
                future: cloudservices.getusername(
                    userid: FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (snapshot.hasData) {
                    return Text(user != null
                        ? (user.displayName == null
                            ? snapshot.data!
                            : user.displayName!)
                        : 'null');
                  } else {
                    return Text('data');
                  }
                },
              ),
              accountEmail: Text(user != null ? user.email! : 'null'),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 55,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : NetworkImage(
                        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home_outlined),
              onTap: () {
                Get.to(() => Home());
              },
            ),
            ListTile(
              title: Text('My products'),
              leading: Icon(Icons.add_shopping_cart_rounded),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CheckOut()));
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(Icons.help),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => About()));
              },
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout_outlined),
              onTap: () async {
                await authservices.SignOut();
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Home',
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
                onPressed: () {
                  Get.to(() => CheckOut());
                },
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
                          '\$ ${snapshot.data!}',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 33,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Get.to(() => Details(
                      path: items[index].path,
                      price: items[index].price,
                      description: dec1,
                    ));
              },
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: -9,
                    top: -3,
                    child: GridTile(
                      child: ClipRRect(
                        child: Image.asset(items[index].path),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      footer: GridTileBar(
                        leading: Text(
                          '\$ ${items[index].price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(''),
                        trailing: Consumer<CloudServices>(
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () async {
                                value.cloudadditem(item: items[index]);
                              },
                              icon: Icon(Icons.add),
                              color: Colors.black,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}
