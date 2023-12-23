import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/models/Item.dart';
import 'package:flutter/material.dart';

class CloudServices with ChangeNotifier {
  final itemsdatabase = FirebaseFirestore.instance.collection('flowerslist');
  final userdatabase = FirebaseFirestore.instance.collection('users');
  double sum = 0;
  static final CloudServices _shared = CloudServices._shareInstance();
  CloudServices._shareInstance();

  factory CloudServices() => _shared;

  Future<void> cloudAdduser({
    required String username,
    required String age,
    required String email,
    required String password,
  }) async {
    await userdatabase.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'username': username,
      'age': age,
      'email': email,
      'password': password,
    }).then((value) => print('user added'));

    notifyListeners();
  }

  Future<void> cloudadditem({required Item item}) async {
    await itemsdatabase.add({
      'id': item.userid,
      'name': item.name,
      'path': item.path,
      'price': item.price,
      'location': item.location,
    });
    notifyListeners();
  }

  Future<String> getusername({required String userid}) async {
    return await userdatabase
        .doc(userid)
        .get()
        .then((value) => value.data()?['username']);
  }

  Future<String> getuserage({required String userid}) async {
    return await userdatabase
        .doc(userid)
        .get()
        .then((value) => value.data()?['age']);
  }

  Future<Iterable<Item>> getdata({required String userid}) async {
    return await itemsdatabase
        .where('id', isEqualTo: userid)
        .get()
        .then((value) => value.docs.map((e) => Item.fromSnapshot(e)));
  }

  double allpricecounter({required Iterable<Item> data}) {
    double sum = 0;
    for (var i in data) {
      sum += i.price;
    }
    return sum;
  }

  Future<double> allprice({required String userid}) async {
    final data = await getdata(userid: userid);
    final price = allpricecounter(data: data);
    notifyListeners();
    return price;
  }

  Future<void> clouddelete({required String documentid}) async {
    await itemsdatabase.doc(documentid).delete();
  }

  Future<int> datalength({required String userid}) async {
    final data = await getdata(userid: userid);
    notifyListeners();
    return data.length;
  }

  Stream<Iterable<Item>> allNotes({required String owneruserid}) =>
      itemsdatabase.snapshots().map((event) => event.docs
          .map((doc) => Item.fromSnapshot(doc))
          .where((item) => item.userid == owneruserid));
}
