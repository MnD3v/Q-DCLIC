// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
class Question {
  String? image;
  String question;
  Map<String, String> choix;
  dynamic reponse;
  String type;
  Question({
    this.image,
    required this.question,
    required this.choix,
    required this.reponse,
    required this.type,
  });

  Question copyWith({
    String? image,
    String? question,
    Map<String, String>? choix,
    dynamic? reponse,
    String? type,
  }) {
    return Question(
      image: image ?? this.image,
      question: question ?? this.question,
      choix: choix ?? this.choix,
      reponse: reponse ?? this.reponse,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'question': question,
      'choix': choix,
      'reponse': reponse,
      'type': type,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      image: map['image'] != null ? map['image'] as String : null,
      question: map['question'] as String,
      choix: Map<String, String>.from((map['choix'])),
      reponse: map['reponse'] as dynamic,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Question(image: $image, question: $question, choix: $choix, reponse: $reponse, type: $type)';
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;
  
    return 
      other.image == image &&
      other.question == question &&
      mapEquals(other.choix, choix) &&
      other.reponse == reponse &&
      other.type == type;
  }

  @override
  int get hashCode {
    return image.hashCode ^
      question.hashCode ^
      choix.hashCode ^
      reponse.hashCode ^
      type.hashCode;
  }
}
