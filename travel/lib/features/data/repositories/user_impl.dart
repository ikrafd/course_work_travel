// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/data/models/user.dart';
import 'package:travel/features/domain/entities/user.dart';
import 'package:travel/features/domain/repository/user_repository.dart';

class FirebaseUserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseService().firestore.collection('user');
  final FirebaseFirestore _firestore = FirebaseService().firestore;

  FirebaseUserRepositoryImpl({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  
  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser){
      return firebaseUser;
    });
  }


  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
    }catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp(UserModel myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
         password: password
         );
       myUser = myUser.copyWith(
        userID: user.user!.uid
       );

       return myUser;
    }catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(UserModel user)  async {
    try {
      await userCollection
        .doc(user.userID)
        .set(user.toEntity().toDocument());
    } catch (e){
      log(e.toString());
      rethrow;
    }
  }

  @override 
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String?> getUserID() async {
    User? user = _firebaseAuth.currentUser; 
    return user?.uid;
  }

  @override
  Future<UserEntity> getUserData() async {
    try {
      String? userID = await getUserID(); 
      if (userID == null) {
        throw Exception('User is not authenticated');
      }
      var docSnapshot = await userCollection.doc(userID).get();
      if (!docSnapshot.exists) {
        throw Exception('User data not found');
      }
      UserEntity user = UserEntity.fromDocument(docSnapshot.data()!);

      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

    @override
  Future<void> updateUserCounters(int tripsCount, int citiesCount) async {
    try {
      String? userID = await getUserID();

      if (userID != null) {
        await _firestore.collection('user').doc(userID).update({
          'tripsCount': FieldValue.increment(tripsCount),
          'citiesCount': FieldValue.increment(citiesCount), 
        });
      } else {
        throw Exception('User is not authenticated');
      }
    } catch (e) {
      throw Exception('Failed to update counters: $e');
    }
  }
  @override
  Future<void> updateUserBudget(double budget) async {
    try{
      String? userID = await getUserID();

      if (userID != null) {
        await _firestore.collection('user').doc(userID).update({
          'spentMoney': FieldValue.increment(budget), 
        });
      } else {
        throw Exception('User is not authenticated');
      }
    } catch (e) {
      throw Exception('Failed to update counters: $e');
    }
  }
  @override
  Future<void> updateUserPalces(int placeCounter) async {
    try{
      String? userID = await getUserID();

      if (userID != null) {
        await _firestore.collection('user').doc(userID).update({
          'visitedPlacesCount': FieldValue.increment(placeCounter), 
        });
      } else {
        throw Exception('User is not authenticated');
      }
    } catch (e) {
      throw Exception('Failed to update counters: $e');
    }
  }
  
}
