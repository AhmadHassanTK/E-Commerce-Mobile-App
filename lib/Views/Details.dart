// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/CloudProvider/CloudServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  final String path;
  final double price;
  final String description;

  const Details({
    super.key,
    required this.path,
    required this.price,
    required this.description,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isShowmore = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Details',
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
          child: Column(
            children: [
              Image.asset(widget.path),
              SizedBox(height: 10),
              Text(
                '\$ ${widget.price}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        Text('Flower Shop'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Details :",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.description}",
                  maxLines: isShowmore ? 3 : null,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isShowmore = !isShowmore;
                  });
                },
                child: Text(isShowmore ? 'Show more' : 'Show less'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
