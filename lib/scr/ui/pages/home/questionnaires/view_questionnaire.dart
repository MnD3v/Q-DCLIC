// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/widgets/bottom_navigation_widget.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class ViewQuestionnaire extends StatelessWidget {
  Questionnaire questionnaire;
  ViewQuestionnaire({super.key, required this.questionnaire});

  var initalResponses = [];

  var dejaRepondu = false.obs;

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  PageController pageController = PageController();

  var loading = false.obs;

  @override
  Widget build(BuildContext context) {
    var telephone = Utilisateur.currentUser.value!.telephone.numero;
    dejaRepondu.value = questionnaire!.maked.keys.contains(telephone);

    if (!questionnaire!.maked.containsKey(telephone)) {
      _initialiseResponses();
    } else {
      initalResponses = questionnaire!.maked[telephone]!.response;
    }
    return EScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d1b2a),
        surfaceTintColor: Color(0xff0d1b2a),
        title: EText("Questionnaire"),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        child: EColumn(children: [
          12.h,
          Container(
            width: Get.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EText(
                questionnaire!.title.toUpperCase(),
                align: TextAlign.center,
                size: 24,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          12.h,
          ...questionnaire!.questions.map((element) {
            var qcmResponse = RxList<String>([]);
            var qcuResponse = "".obs;
            var index = questionnaire!.questions.indexOf(element);
            return QuestionCard(
                element: element,
                index: index,
                dejaRepondu: dejaRepondu,
                qcuResponse: qcuResponse,
                questionnaire: questionnaire,
                initalResponses: initalResponses,
                qcmResponse: qcmResponse);
          }).toList(),
          12.h,
          Obx(
            () => dejaRepondu.value
                ? 0.h
                : SimpleButton(
                    radius: 12,
                    color: const Color.fromARGB(255, 0, 114, 59),
                    onTap: () async {
                      loading.value = true;

                      var points = 0.0;
                      print(initalResponses);
                      //parcourir les question
                      for (var i = 0;
                          i < questionnaire!.questions.length;
                          i++) {
                        var currentQuestion = questionnaire!.questions[i];
                        //QCM
                        if (currentQuestion.type == QuestionType.qcm) {
                          for (var element in initalResponses[i] as List) {
                            if (currentQuestion.reponse.contains(element)) {
                              points +=
                                  1 / (currentQuestion.reponse as List).length;
                            } else {
                              points -=
                                  1 / (currentQuestion.reponse as List).length;
                            }
                          }
                        }
                        //QCU
                        else if (currentQuestion.type == QuestionType.qcu) {
                          if (currentQuestion.reponse == initalResponses[i]) {
                            points += 1;
                          }
                        }
                      }

                      await saveInformations(points);
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
      ),
    
      floatingActionButton: GestureDetector(
        onTap: () {
          var _id = "";
          // showInputDialogForId(_id);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage(Assets.icons("view_questions.png")),
              height: 50,
              color: Colors.greenAccent,
            ),
            Icon(
              Icons.question_mark_rounded,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveInformations(double points) async {
    var telephone = Utilisateur.currentUser.value!.telephone.numero;
    var user = Utilisateur.currentUser.value!;
    //mis a jour de la reponse de l'utilisateur
    questionnaire!.maked.putIfAbsent(
        telephone,
        () => Maked(
            date: DateTime.now().toString(),
            nom: user.nom,
            prenom: user.prenom,
            response: initalResponses,
            pointsGagne: points));
    //mis a jour de la reponse de l'utilisateur

    await DB
        .firestore(Collections.classes)
        .doc("Classe 1")
        .collection(Collections.questionnaires)
        .doc(questionnaire.id)
        .set(questionnaire!.toMap());
    Utilisateur.currentUser.value!.points += points;
    totalPoints.value = Utilisateur.currentUser.value!.points;
    await Utilisateur.setUser(Utilisateur.currentUser.value!);
    waitAfter(4000, () {
      loading.value = false;
      showDialogForScrore(points);
      dejaRepondu.value = true;
    });
  }

  void showDialogForScrore(double points) {
    return Custom.showDialog(
        barrierColor: Colors.white24,
        dialog: Dialog(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          surfaceTintColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: EColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  12.h,
                  EText(
                    questionnaire!.title.toUpperCase(),
                    align: TextAlign.center,
                    color: Colors.white,
                    size: 24,
                  ),
                  Image(
                    image: AssetImage(Assets.icons("diamant.png")),
                    height: 60,
                  ),
                  EText(
                    "Votre score",
                    color: Colors.white,
                    size: 24,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EText(
                        points.toStringAsFixed(2),
                        font: Fonts.sevenSegment,
                        size: 65,
                        color: const Color.fromARGB(255, 21, 255, 0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: EText(
                          "/" + questionnaire!.questions.length.toString(),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          size: 24,
                        ),
                      )
                    ],
                  ),
                  SimpleOutlineButton(
                      radius: 9,
                      color: Colors.white60,
                      onTap: () {
                        Get.back();
                      },
                      child: EText(
                        "Fermer",
                        color: Colors.white54,
                      ))
                ]),
          ),
        ));
  }

  // void showInputDialogForId(String _id) {
  //   Custom.showDialog(
  //       dialog: Dialog(
  //         backgroundColor: Colors.black,
  //         surfaceTintColor: Colors.black,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
  //           child: EColumn(children: [
  //             EText("Entrez l'ID du questionnaire"),
  //             12.h,
  //             ETextField(
  //                 placeholder: "Saisissez l'ID",
  //                 border: true,
  //                 color: Colors.black,
  //                 onChanged: (value) {
  //                   _id = value;
  //                 },
  //                 phoneScallerFactor: phoneScallerFactor),
  //             12.h,
  //             SimpleOutlineButton(
  //               radius: 9,
  //               color: Colors.greenAccent,
  //               onTap: () {
  //                 id = _id;
  //                 Get.back();
  //               },
  //               child: EText(
  //                 "Continuer",
  //                 color: Colors.greenAccent,
  //               ),
  //             )
  //           ]),
  //         ),
  //       ),
  //       barrierColor: Colors.white24);
  // }

  _initialiseResponses() {
    initalResponses = questionnaire!.questions
        .map((element) => element.type == QuestionType.qcm ? [] : "")
        .toList();
  }
}
