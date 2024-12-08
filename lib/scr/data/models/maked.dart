// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Maked {
  String nom;
  String prenom;
  List<dynamic> response;
  double pointsGagne;
  Maked({
    required this.nom,
    required this.prenom,
    required this.response,
    required this.pointsGagne,
  });

  Maked copyWith({
    String? nom,
    String? prenom,
    List<dynamic>? response,
    double? pointsGagne,
  }) {
    return Maked(
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      response: response ?? this.response,
      pointsGagne: pointsGagne ?? this.pointsGagne,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'response': jsonEncode(response),
      'pointsGagne': pointsGagne,
    };
  }

  factory Maked.fromMap(Map<String, dynamic> map) {
    return Maked(
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      response: List<dynamic>.from((jsonDecode(map['response']) as List<dynamic>)),
      pointsGagne: map['pointsGagne'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maked.fromJson(String source) => Maked.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Maked(nom: $nom, prenom: $prenom, response: $response, pointsGagne: $pointsGagne)';
  }



  @override
  int get hashCode {
    return nom.hashCode ^
      prenom.hashCode ^
      response.hashCode ^
      pointsGagne.hashCode;
  }
}
