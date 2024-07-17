import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // Hata yönetimi
      print('Giriş yaparken hata: $e');
      return null;
    }
  }

  // Çıkış yap fonksiyonu
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Hata yönetimi
      print('Çıkış yaparken hata: $e');
    }
  }

  // Kayıt ol fonksiyonu
  Future<User?> createPerson(String name, String email, String password) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Firestore'a kullanıcı bilgilerini kaydet
      await _firestore.collection("Person").doc(userCredential.user!.uid).set({
        'userName': name,
        'email': email,
      });

      return userCredential.user;
    } catch (e) {
      // Hata yönetimi
      print('Kayıt olurken hata: $e');
      return null;
    }
  }
}
