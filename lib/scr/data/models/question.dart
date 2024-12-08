import 'package:flutter/foundation.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
class Question {
  String question;
  Map<String, String> choix;
  dynamic reponse;
  bool qcm;
  Question({
    required this.question,
    required this.choix,
    required this.reponse,
    required this.qcm,
  });

  Question copyWith({
    String? question,
    Map<String, String>? choix,
    dynamic? reponse,
    bool? qcm,
  }) {
    return Question(
      question: question ?? this.question,
      choix: choix ?? this.choix,
      reponse: reponse ?? this.reponse,
      qcm: qcm ?? this.qcm,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'choix': choix,
      'reponse': reponse,
      'qcm': qcm,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] as String,
      choix: Map<String, String>.from((map['choix'])),
      reponse: map['reponse'] as dynamic,
      qcm: map['qcm'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Question(question: $question, choix: $choix, reponse: $reponse, qcm: $qcm)';
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        mapEquals(other.choix, choix) &&
        other.reponse == reponse &&
        other.qcm == qcm;
  }

  @override
  int get hashCode {
    return question.hashCode ^ choix.hashCode ^ reponse.hashCode ^ qcm.hashCode;
  }
}
