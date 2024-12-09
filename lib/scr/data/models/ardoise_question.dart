// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';

class ArdoiseQuestion {
  String date;
  String? image;
  String question;
  String id;
  Map<String, String> choix;
  dynamic reponse;
  String type;
  Map<String, Maked> maked;

  ArdoiseQuestion({
    required this.date,
    this.image,
    required this.question,
    required this.id,
    required this.choix,
    required this.reponse,
    required this.type,
    required this.maked,
  });

  ArdoiseQuestion copyWith({
    String? image,
    String? question,
    String? id,
    Map<String, String>? choix,
    dynamic? reponse,
    String? type,
    Map<String, Maked>? maked,
  }) {
    return ArdoiseQuestion(
      date: date?? this.date,
      image: image ?? this.image,
      question: question ?? this.question,
      id: id ?? this.id,
      choix: choix ?? this.choix,
      reponse: reponse ?? this.reponse,
      type: type ?? this.type,
      maked: maked ?? this.maked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date':date,
      'image': image,
      'question': question,
      'id': id,
      'choix': choix,
      'reponse': reponse,
      'type': type,
      'maked': maked.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory ArdoiseQuestion.fromMap(Map<String, dynamic> map) {
    return ArdoiseQuestion(
      date: map['date'],
      image: map['image'] != null ? map['image'] as String : null,
      question: map['question'] as String,
      id: map['id'] as String,
      choix: Map<String, String>.from((map['choix'])),
      reponse: map['reponse'] as dynamic,
      type: map['type'] as String,
      maked: (map['maked'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Maked.fromMap(value))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArdoiseQuestion.fromJson(String source) =>
      ArdoiseQuestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArdoiseQuestion(image: $image, question: $question, id: $id, choix: $choix, reponse: $reponse, type: $type, maked: $maked)';
  }

  @override
  bool operator ==(covariant ArdoiseQuestion other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.question == question &&
        other.id == id &&
        mapEquals(other.choix, choix) &&
        other.reponse == reponse &&
        other.type == type &&
        mapEquals(other.maked, maked);
  }

  @override
  int get hashCode {
    return image.hashCode ^
        question.hashCode ^
        id.hashCode ^
        choix.hashCode ^
        reponse.hashCode ^
        type.hashCode ^
        maked.hashCode;
  }
}
