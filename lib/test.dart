// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/my_widgets.dart';

class Utilisateur {
  double points;
  String nom;
  String prenom;
  String classe;
  String? country;
  String? token;
  String password;
  Telephone telephone;
  String id;
  Utilisateur({
    required this.points,
    required this.nom,
    required this.prenom,
    required this.classe,
    this.country,
    this.token,
    required this.password,
    required this.telephone,
    required this.id,
  });

  Utilisateur copyWith({
    double? points,
    String? nom,
    String? prenom,
    String? classe,
    String? country,
    String? token,
    String? password,
    Telephone? telephone,
    String? id,
  }) {
    return Utilisateur(
      points: points ?? this.points,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      classe: classe ?? this.classe,
      country: country ?? this.country,
      token: token ?? this.token,
      password: password ?? this.password,
      telephone: telephone ?? this.telephone,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'points': points,
      'nom': nom,
      'prenom': prenom,
      'classe': classe,
      'country': country,
      'token': token,
      'password': password,
      'telephone': telephone.toMap(),
      'id': id,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      points: map['points'] as double,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      classe: map['classe'] as String,
      country: map['country'] != null ? map['country'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      password: map['password'] as String,
      telephone: Telephone.fromMap(map['telephone'] as Map<String,dynamic>),
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Utilisateur.fromJson(String source) => Utilisateur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Utilisateur(points: $points, nom: $nom, prenom: $prenom, classe: $classe, country: $country, token: $token, password: $password, telephone: $telephone, id: $id)';
  }

  @override
  bool operator ==(covariant Utilisateur other) {
    if (identical(this, other)) return true;
  
    return 
      other.points == points &&
      other.nom == nom &&
      other.prenom == prenom &&
      other.classe == classe &&
      other.country == country &&
      other.token == token &&
      other.password == password &&
      other.telephone == telephone &&
      other.id == id;
  }

  @override
  int get hashCode {
    return points.hashCode ^
      nom.hashCode ^
      prenom.hashCode ^
      classe.hashCode ^
      country.hashCode ^
      token.hashCode ^
      password.hashCode ^
      telephone.hashCode ^
      id.hashCode;
  }
}
