import 'package:cloud_firestore/cloud_firestore.dart';

class Nesne {
  late String tr;
  late String en;
  late String id;

  Nesne.fromDocument(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data() as dynamic;
    tr = data['name_tr'];
    en = data['name_en'];
    id = snapshot.id;
  }
}

class AnasayfaNesne {
  late String tr;
  late String en;
  late String id;
  late String page_route;

  AnasayfaNesne.fromDocument(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data() as dynamic;
    tr = data['name_tr'];
    en = data['name_en'];
    page_route = data['page_route'];
    id = snapshot.id;
  }
}

class HayvanNesne {
  late String tr;
  late String en;
  late String id;

  HayvanNesne.fromDocument(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data() as dynamic;
    tr = data['name_tr'];
    en = data['name_en'];
    id = snapshot.id;
  }
}

class LoginNesne {
  late String id;
  late String page_route;

  LoginNesne.fromDocument(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data() as dynamic;
    page_route = data['page_route'];
    id = snapshot.id;
  }
}
