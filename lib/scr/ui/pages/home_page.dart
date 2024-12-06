// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/widgets/bottom_navigation_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initalResponses = [];

  var dejaRepondu = false.obs;

  var id = "".obs;

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  Questionnaire? questionnaire;

  PageController pageController = PageController();

  var loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d1b2a),
        surfaceTintColor: Color(0xff0d1b2a),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image(
              image: AssetImage(Assets.image("question.png")),
              height: 30,
            ),
            9.w,
            Image(
              image: AssetImage(Assets.image("logo.png")),
              height: 35,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image(
                  image: AssetImage(Assets.icons("diamant.png")),
                  height: 26,
                ),
                3.w,
                Obx(
                  () => EText(
                    totalPoints.value.toStringAsFixed(2),
                    weight: FontWeight.bold,
                    color: Colors.greenAccent,
                    size: 39,
                    font: "SevenSegment",
                  ),
                ),
                3.w,
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: EText(
                    "pts",
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      color: Color(0xFF1b263b),
      body: PageView(
        controller: pageController,
        children: [
          Obx(
            () => 
            id.value.isEmpty? Center(
              child: EText("Entrez l'ID du Questionnaire"),
            ):
            FutureBuilder(
                key: Key(id.value),
                future: DB
                    .firestore(Collections.questionnaires)
                    .doc(id.value)
                    .get(),
                builder: (context, snapshot) {
                  if (DB.waiting(snapshot)) {
                    return ECircularProgressIndicator();
                  }

                  if (snapshot.data != null && snapshot.data!.exists) {
                    questionnaire =
                        Questionnaire.fromMap(snapshot.data!.data()!);

                    dejaRepondu.value = questionnaire!.maked.contains(
                        Utilisateur.currentUser.value!.telephone.numero);
                    print("++++++++++++++");
                    print(questionnaire!.myResponses);
                    print("++++++++++++++");

                    if (questionnaire!.myResponses.isEmpty) {
                      _initialiseResponses();
                    } else {
                      initalResponses = questionnaire!.myResponses;
                    }
                    print(initalResponses);
                    print(questionnaire);
                  } else {
                    questionnaire = null;
                  }

                  return questionnaire == null
                      ? Center(
                          child: EColumn(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                               
                                EText(
                                  "Oops !!! Questionnaire Introuvable.",
                                  color: const Color.fromARGB(255, 255, 0, 85),
                                  size: 24,
                                ),
                              ]),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: EColumn(children: [
                            12.h,
                            Container(
                              width: Get.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EText(
                                  questionnaire!.title.toUpperCase(),
                                  align: TextAlign.center,
                                  size: 24,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                            12.h,
                            ...questionnaire!.questions.map((element) {
                              var qcmResponse = RxList<String>([]);
                              var qcuResponse = "".obs;
                              var index =
                                  questionnaire!.questions.indexOf(element);
                              return Container(
                                width: Get.width,
                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                    color: Color(0xff0d1b2a),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        width: .5, color: Colors.white54)),
                                margin: EdgeInsets.symmetric(vertical: 6),
                                child: EColumn(children: [
                                  EText(
                                    (index + 1).toString(),
                                    font: Fonts.sevenSegment,
                                    size: 62,
                                    color:
                                        Colors.greenAccent,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: EText(
                                      element.question,
                                      color: const Color.fromARGB(
                                          255, 182, 182, 182),
                                      size: 22,
                                    ),
                                  ),
                                  DottedDashedLine(
                                    height: 0,
                                    width: Get.width,
                                    axis: Axis.horizontal,
                                    dashColor: Colors.white54,
                                  ),
                                  Obx(
                                    () => EColumn(
                                        children: element.choix.keys.map((e) {
                                      return !element.qcm
                                          ? IgnorePointer(
                                              ignoring: dejaRepondu.value,
                                              child: RadioListTile(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        qcuResponse.value == e
                                                            ? Colors.amber
                                                            : Colors.grey),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0),
                                                value: e,
                                                groupValue: qcuResponse.value,
                                                onChanged: (value) {
                                                  qcuResponse.value =
                                                      value as String;
                                                  var index = questionnaire!
                                                      .questions
                                                      .indexOf(element);
                                                  initalResponses[index] =
                                                      qcuResponse.value;
                                                },
                                                title: EText(
                                                  element.choix[e],
                                                  color: dejaRepondu.value &&
                                                          element.reponse == e
                                                      ?  Colors.greenAccent
                                                      : dejaRepondu.value &&
                                                              initalResponses[
                                                                      index] ==
                                                                  e
                                                          ? Colors.red
                                                          : Colors.white,
                                                ),
                                              ),
                                            )
                                          : CheckboxListTile(
                                              enabled: !dejaRepondu.value,
                                              fillColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      qcmResponse.contains(e)
                                                          ? Colors.amber
                                                          : Colors.transparent),
                                              activeColor: Colors.amber,
                                              side: BorderSide(
                                                  width: 2, color: Colors.grey),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0),
                                              value: qcmResponse.contains(e),
                                              onChanged: (value) {
                                                qcmResponse.contains(e)
                                                    ? qcmResponse.remove(e)
                                                    : qcmResponse.add(e);
                                                var index = questionnaire!
                                                    .questions
                                                    .indexOf(element);
                                                initalResponses[index] =
                                                    qcmResponse.value;
                                              },
                                              title: EText(
                                                element.choix[e],
                                                color: dejaRepondu.value &&
                                                        element.reponse
                                                            .contains(e)
                                                    ?  Colors.greenAccent
                                                    : dejaRepondu.value &&
                                                            initalResponses[
                                                                    index]
                                                                .contains(e)
                                                        ? Colors.red
                                                        : Colors.white,
                                              ),
                                            );
                                    }).toList()),
                                  )
                                ]),
                              );
                            }).toList(),
                            12.h,
                            Obx(
                              () => dejaRepondu.value
                                  ? 0.h
                                  : SimpleButton(
                                      radius: 12,
                                      color:
                                          const Color.fromARGB(255, 0, 114, 59),
                                      onTap: () async {
                                        loading.value = true;

                                        var points = 0.0;
                                        print(initalResponses);
                                        for (var i = 0;
                                            i < questionnaire!.questions.length;
                                            i++) {
                                          var currentQuestion =
                                              questionnaire!.questions[i];
                                          if (currentQuestion.qcm) {
                                            for (var element
                                                in initalResponses[i] as List) {
                                              if (currentQuestion.reponse
                                                  .contains(element)) {
                                                points += 1 /
                                                    (currentQuestion.reponse
                                                            as List)
                                                        .length;
                                              } else {
                                                points -= 1 /
                                                    (currentQuestion.reponse
                                                            as List)
                                                        .length;
                                              }
                                            }
                                          } else {
                                            print("----------");
                                            print(currentQuestion.reponse ==
                                                initalResponses[i]);
                                            print(initalResponses[i].length);
                                            print(
                                                currentQuestion.reponse.length);
                                            print("----------");

                                            if (currentQuestion.reponse ==
                                                initalResponses[i]) {
                                              points += 1;
                                            }
                                          }
                                        }
                                        var telephone = Utilisateur.currentUser
                                            .value!.telephone.numero;
                                        await DB
                                            .firestore(
                                                Collections.questionnaires)
                                            .doc(id.value)
                                            .set(questionnaire!.copyWith(
                                                maked: [
                                                  ...questionnaire!.maked,
                                                  telephone
                                                ],
                                                myResponses:
                                                    initalResponses).toMap());
                                        Utilisateur.currentUser.value!.points +=
                                            points;
                                            totalPoints.value = Utilisateur.currentUser.value!.points;
                                        await Utilisateur.setUser(
                                            Utilisateur.currentUser.value!);
                                        waitAfter(4000, () {
                                          loading.value = false;
                                          Custom.showDialog(
                                              barrierColor: Colors.white24,
                                              dialog: Dialog(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                surfaceTintColor: Colors.black,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: EColumn(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        12.h,
                                                        EText(
                                                          questionnaire!.title
                                                              .toUpperCase(),
                                                          align:
                                                              TextAlign.center,
                                                          color: Colors.white,
                                                          size: 24,
                                                        ),
                                                        Image(
                                                          image: AssetImage(
                                                              Assets.icons(
                                                                  "diamant.png")),
                                                          height: 60,
                                                        ),
                                                        EText(
                                                          "Votre score",
                                                          color: Colors.white,
                                                          size: 24,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            EText(
                                                              points
                                                                  .toStringAsFixed(
                                                                      2),
                                                              font: Fonts
                                                                  .sevenSegment,
                                                              size: 65,
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  21, 255, 0),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          6.0),
                                                              child: EText(
                                                                "/" +
                                                                    questionnaire!
                                                                        .questions
                                                                        .length
                                                                        .toString(),
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                                size: 24,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SimpleOutlineButton(
                                                            radius: 9,
                                                            color:
                                                                Colors.white60,
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            child: EText(
                                                              "Fermer",
                                                              color: Colors
                                                                  .white54,
                                                            ))
                                                      ]),
                                                ),
                                              ));
                                        dejaRepondu.value = true;

                                        });
                                      },
                                      child: Obx(() => loading.value
                                          ? ECircularProgressIndicator(
                                            height: 30.0,
                                          )
                                          : EText("Soumettre")),
                                    ),
                            ),
                            24.h
                          ]),
                        );
                }),
          ),
          Compte()
        ],
      ),
      bottomNavigationBar: MBottomNavigationBar(
          ready: true.obs, pageController: pageController, currentPage: 0.obs),
      floatingActionButton: GestureDetector(
        onTap: () {
          var _id = "";
          Custom.showDialog(
              dialog: Dialog(
                backgroundColor: Colors.black,
                surfaceTintColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
                  child: EColumn(children: [
                    EText("Entrez l'ID du questionnaire"),
                    12.h,
                    ETextField(
                      placeholder: "Saisissez l'ID" ,
                      border: true,
                      color: Colors.black,
                        onChanged: (value) {
                          _id = value;
                        },
                        phoneScallerFactor: phoneScallerFactor),
                    12.h,
                    SimpleOutlineButton(
                      radius: 9,
                      color: Colors.greenAccent,
                      onTap: () {
                        id.value = _id;
                        Get.back();
                      },
                      child: EText(
                        "Continuer",
                        color: Colors.greenAccent,
                      ),
                    )
                  ]),
                ),
              ),
              barrierColor: Colors.white24);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: AssetImage(Assets.icons("view_questions.png")), height: 50, color: Colors.greenAccent,),
            Icon(Icons.question_mark_rounded, color: Colors.black,)
          ],
        ),
      ),
    );
  }

  _initialiseResponses() {
    initalResponses = questionnaire!.questions
        .map((element) => element.qcm ? [] : "")
        .toList();
  }
}

class Questionnaire {
  String title;
  List<String> maked;
  List<Question> questions;
  List<dynamic> myResponses;
  Questionnaire({
    required this.title,
    required this.maked,
    required this.questions,
    required this.myResponses,
  });

  Questionnaire copyWith({
    String? title,
    List<String>? maked,
    List<Question>? questions,
    List<dynamic>? myResponses,
  }) {
    return Questionnaire(
      title: title ?? this.title,
      maked: maked ?? this.maked,
      questions: questions ?? this.questions,
      myResponses: myResponses ?? this.myResponses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'maked': maked,
      'questions': questions.map((x) => x.toMap()).toList(),
      'myResponses': jsonEncode(myResponses),
    };
  }

  factory Questionnaire.fromMap(Map<String, dynamic> map) {
    return Questionnaire(
      title: map['title'] as String,
      maked: List<String>.from((map['maked'])),
      questions: List<Question>.from(
        (map['questions']).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
      myResponses: List<dynamic>.from((jsonDecode(map['myResponses']))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Questionnaire.fromJson(String source) =>
      Questionnaire.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Questionnaire(title: $title, maked: $maked, questions: $questions, myResponses: $myResponses)';
  }

  @override
  bool operator ==(covariant Questionnaire other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        listEquals(other.maked, maked) &&
        listEquals(other.questions, questions) &&
        listEquals(other.myResponses, myResponses);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        maked.hashCode ^
        questions.hashCode ^
        myResponses.hashCode;
  }
}

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
