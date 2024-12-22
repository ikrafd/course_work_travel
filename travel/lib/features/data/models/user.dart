// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/entities/user.dart';

class UserModel extends Equatable {
  final String userID;
  final String email;
  final String name;
  final int tripsCount;
  final int visitedPlacesCount;
  final double spentMoney;
  final int citiesCount; 

  const UserModel({
    required this.userID,
    required this.email,
    required this.name,
    this.tripsCount = 0,
    this.visitedPlacesCount = 0,
    this.spentMoney = 0.0,
    this.citiesCount = 0,
  });

  static const empty = UserModel(
    userID: '', 
    email: '',
    name: '',
    tripsCount: 0,
    visitedPlacesCount: 0,
    spentMoney: 0.0,
    citiesCount: 0,
  );

  UserModel copyWith({
    String? userID,
    String? email,
    String? name,
    int? tripsCount,
    int? visitedPlacesCount,
    double? spentMoney,
    int? travelDaysCount,
    int? citiesCount, 
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      email: email ?? this.email,
      name: name ?? this.name,
      tripsCount: tripsCount ?? this.tripsCount,
      visitedPlacesCount: visitedPlacesCount ?? this.visitedPlacesCount,
      spentMoney: spentMoney ?? this.spentMoney,
      citiesCount: citiesCount ?? this.citiesCount, 
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userID: userID,
      email: email,
      name: name,
      tripsCount: tripsCount,
      visitedPlacesCount: visitedPlacesCount,
      spentMoney: spentMoney,
      citiesCount: citiesCount, 
    );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      userID: entity.userID,
      email: entity.email,
      name: entity.name,
      tripsCount: entity.tripsCount,
      visitedPlacesCount: entity.visitedPlacesCount,
      spentMoney: entity.spentMoney,
      citiesCount: entity.citiesCount,
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
