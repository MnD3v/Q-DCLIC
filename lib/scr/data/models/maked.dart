// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class Maked {
  String nom;
  String date;
  String prenom;
  List<dynamic> response;
  double pointsGagne;
  Maked({
    required this.nom,
    required this.date,
    required this.prenom,
    required this.response,
    required this.pointsGagne,
  });

  Maked copyWith({
    String? nom,
    String? date,
    String? prenom,
    List<dynamic>? response,
    double? pointsGagne,
  }) {
    return Maked(
      nom: nom ?? this.nom,
      date: date ?? this.date,
      prenom: prenom ?? this.prenom,
      response: response ?? this.response,
      pointsGagne: pointsGagne ?? this.pointsGagne,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'date': date,
      'prenom': prenom,
      'response': jsonEncode(response),
      'pointsGagne': pointsGagne,
    };
  }

  factory Maked.fromMap(Map<String, dynamic> map) {
    return Maked(
      nom: map['nom'] as String,
      date: map['date'] as String,
      prenom: map['prenom'] as String,
      response: jsonDecode(map['response']),
      pointsGagne: map['pointsGagne'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maked.fromJson(String source) =>
      Maked.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Maked(nom: $nom, date: $date, prenom: $prenom, response: $response, pointsGagne: $pointsGagne)';
  }

  @override
  int get hashCode {
    return nom.hashCode ^
        date.hashCode ^
        prenom.hashCode ^
        response.hashCode ^
        pointsGagne.hashCode;
  }

  @override
  bool operator ==(covariant Maked other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.nom == nom &&
        other.date == date &&
        other.prenom == prenom &&
        listEquals(other.response, response) &&
        other.pointsGagne == pointsGagne;
  }
}
