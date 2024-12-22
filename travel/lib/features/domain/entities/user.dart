// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userID;
  final String email;
  final String name;
  final int tripsCount;        
  final int visitedPlacesCount; 
  final double spentMoney;      
  final int citiesCount; 

  const UserEntity({
    required this.userID,
    required this.email,
    required this.name,
    this.tripsCount = 0,           
    this.visitedPlacesCount = 0,   
    this.spentMoney = 0.0,          
    this.citiesCount = 0, 
  });

  Map<String, Object> toDocument() {
    return {
      "userID": userID,
      "email": email,
      "name": name,
      "tripsCount": tripsCount,
      "visitedPlacesCount": visitedPlacesCount,
      "spentMoney": spentMoney,
      "citiesCount": citiesCount, 
    };
  }

   static UserEntity fromDocument(Map<String, dynamic> doc) {
    double spentMoney = doc['spentMoney'] is int
        ? (doc['spentMoney'] as int).toDouble() 
        : (doc['spentMoney'] ?? 0.0).toDouble(); 
    return UserEntity(
      userID: doc['userID'] ?? '',
      email: doc['email'] ?? '',
      name: doc['name'] ?? '',
      tripsCount: doc['tripsCount'] ?? 0,
      visitedPlacesCount: doc['visitedPlacesCount'] ?? 0,
      spentMoney: spentMoney,
      citiesCount: doc['citiesCount'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        userID,
        email,
        name,
        tripsCount,
        visitedPlacesCount,
        spentMoney,
        citiesCount, 
      ];
}
