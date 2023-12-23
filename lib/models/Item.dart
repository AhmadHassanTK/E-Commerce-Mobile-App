import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Item {
  String path;
  double price;
  String name;
  String location;
  String userid;
  String? documentid;

  Item({
    required this.path,
    required this.price,
    required this.name,
    required this.location,
    required this.userid,
    this.documentid,
  });

  Item.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : path = snapshot.data()['path'],
        location = snapshot.data()['location'],
        name = snapshot.data()['name'],
        userid = snapshot.data()['id'],
        documentid = snapshot.id,
        price = snapshot.data()['price'];

  static List<Item> getItems() {
    List<Item> items = [
      Item(
          path: "assets/1.webp",
          price: 12.99,
          name: 'Product 1',
          location: 'Main Branch',
          userid: FirebaseAuth.instance.currentUser!.uid),
      Item(
        path: "assets/2.webp",
        price: 12.99,
        name: 'Product 2',
        location: 'October Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
      Item(
        path: "assets/3.webp",
        price: 12.99,
        name: 'Product 3',
        location: 'Main Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
      Item(
        path: "assets/4.webp",
        price: 12.99,
        name: 'Product 4',
        location: 'October Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
      Item(
        path: "assets/5.webp",
        price: 12.99,
        name: 'Product 5',
        location: 'Main Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
      Item(
        path: "assets/6.webp",
        price: 12.99,
        name: 'Product 6',
        location: 'October Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
      Item(
        path: "assets/7.webp",
        price: 12.99,
        name: 'Product 7',
        location: 'Main Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
      Item(
        path: "assets/8.webp",
        price: 12.99,
        name: 'Product 8',
        location: 'October Branch',
        userid: FirebaseAuth.instance.currentUser!.uid,
      ),
    ];

    return items;
  }
}
