import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseFirestore firestore;

  FirebaseService._internal()
      : firestore = FirebaseFirestore.instance;

  factory FirebaseService() {
    return _instance;
  }

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserId() {
    final user = _auth.currentUser;
    return user?.uid ?? ''; 
  }

  Future<String?> getFirebaseIdToken() async {
  final user = _auth.currentUser;
  if (user != null) {
    return await user.getIdToken();
  }
  return null;
}
}