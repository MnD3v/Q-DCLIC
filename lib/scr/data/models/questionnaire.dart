// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';

class Questionnaire {
  String id;
  String date;
  String title;
  Map<String, Maked> maked;
  List<Question> questions;
  Questionnaire({
    required this.id,
    required this.date,
    required this.title,
    required this.maked,
    required this.questions,
  });

  Questionnaire copyWith({
    String? id,
    String? date,
    String? title,
    Map<String, Maked>? maked,
    List<Question>? questions,
  }) {
    return Questionnaire(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      maked: maked ?? this.maked,
      questions: questions ?? this.questions,
    );
  }


   Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'date':date,
      'title': title,
      'maked': maked.map((key, value) => MapEntry(key, value.toMap())),
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory Questionnaire.fromMap(Map<String, dynamic> map) {
    return Questionnaire(
      id: map['id'],
      date: map['date'] as String,
      title: map['title'] as String,
      maked: (map['maked'] as Map<String, dynamic>).map((key, value)=> MapEntry(key, Maked.fromMap(value))),
      questions: List<Question>.from(
        (map['questions']).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Questionnaire.fromJson(String source) =>
      Questionnaire.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Questionnaire(id: $id, date: $date, title: $title, maked: $maked, questions: $questions)';
  }

  @override
  bool operator ==(covariant Questionnaire other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      other.title == title &&
      mapEquals(other.maked, maked) &&
      listEquals(other.questions, questions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      title.hashCode ^
      maked.hashCode ^
      questions.hashCode;
  }
}
