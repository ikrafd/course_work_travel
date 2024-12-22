import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/features/data/models/user.dart';
import 'package:travel/features/domain/entities/user.dart';


abstract class UserRepository {
  Stream <User?> get user;

  Future<UserModel> signUp(UserModel user, String password);

  Future<void> setUserData (UserModel user);

  Future<void> signIn (String email, String password);
   
  Future<void> logOut();

  Future<String?> getUserID();

  Future<void> updateUserCounters(int tripsCount, int citiesCount) ;

  Future<UserEntity> getUserData();

  Future<void> resetPassword(String email);
  Future<void> updateUserBudget(double budget);
  Future<void> updateUserPalces(int placeCounter);
}
