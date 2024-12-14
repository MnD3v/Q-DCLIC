// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';

import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/widgets/question_card.dart';

class ViewQuestionnaire extends StatefulWidget {
  Questionnaire questionnaire;
  RxBool dejaRepondu;

  ViewQuestionnaire(
      {super.key, required this.questionnaire, required this.dejaRepondu});

  @override
  State<ViewQuestionnaire> createState() => _ViewQuestionnaireState();
}

class _ViewQuestionnaireState extends State<ViewQuestionnaire> {
  var initalResponses = [];

  PageController pageController = PageController();

  var loading = false.obs;

  var telephone = Utilisateur.currentUser.value!.telephone_id;

  @override
  void initState() {
    waitAfter(10, () {
      widget.dejaRepondu.value =
          widget.questionnaire!.maked.keys.contains(telephone);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.questionnaire!.maked.containsKey(telephone)) {
      _initialiseResponses();
    } else {
      initalResponses = widget.questionnaire.maked[telephone]!.response;
    }
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      return EScaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: AppColors.background,
          title: EText(
            "Questionnaire",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: DynamicHeightGridView(
                physics: BouncingScrollPhysics(),
                itemCount: widget.questionnaire.questions.length,
                crossAxisCount:
                    crossAxisCount.toInt() <= 0 ? 1 : crossAxisCount.toInt(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                builder: (ctx, index) {
                  var element = widget.questionnaire.questions[index];
                  var qcmResponse = RxList<String>([]);
                  var qcuResponse = "".obs;
                  return QuestionCard(
                      element: element,
                      index: index,
                      dejaRepondu: widget.dejaRepondu,
                      qcuResponse: qcuResponse,
                      questionnaire: widget.questionnaire,
                      initalResponses: initalResponses,
                      qcmResponse: qcmResponse);
                })),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => widget.dejaRepondu.value
                ? 0.h
                : SimpleButton(
                    radius: 12,
                    color: const Color.fromARGB(255, 0, 114, 59),
                    onTap: () async {
               
                      for (var i = 0; i < initalResponses.length; i++) {
                        if (initalResponses[i].isEmpty) {
                          Custom.showDialog(
                              dialog: WarningWidget(
                                  message:
                                      "Veuillez repondre a toutes les questions.\n Exple: La question ${i+1} n'est pas repondue"));
                          return;
                        }
                      }

                      loading.value = true;
                      var points = 0.0;
                      for (var i = 0;
                          i < widget.questionnaire.questions.length;
                          i++) {
                        var currentQuestion = widget.questionnaire.questions[i];
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
        ),
      );
    });
  }

  Future<void> saveInformations(double points) async {
    var telephone = Utilisateur.currentUser.value!.telephone_id;
    var user = Utilisateur.currentUser.value!;
    //mis a jour de la reponse de l'utilisateur
    widget.questionnaire.maked.putIfAbsent(
        telephone,
        () => Maked(
            date: DateTime.now().toString(),
            nom: user.nom,
            prenom: user.prenom,
            response: initalResponses,
            pointsGagne: points));
    //mis a jour de la reponse de l'utilisateur

    //histoire de declancher le stream de recuperation de questionnaire
    widget.questionnaire.date =
        '${widget.questionnaire.date.split(".")[0]}.${Random().nextInt(900)}';
    //histoire de declancher le stream de recuperation de questionnaire

    widget.questionnaire.save(brouillon: false);
    Utilisateur.currentUser.value!.points += points;
    HomePage.totalPoints.value = Utilisateur.currentUser.value!.points;
    await Utilisateur.setUser(Utilisateur.currentUser.value!);
    waitAfter(4000, () {
      loading.value = false;
      showDialogForScrore(points);
      widget.dejaRepondu.value = true;
    });
  }

  void showDialogForScrore(double points) {
    return Custom.showDialog(
        barrierColor: Colors.black12,
        dialog: Score(
          questionnaire: widget.questionnaire,
          points: points,
        ));
  }

  // void showInputDialogForId(String _id) {
  _initialiseResponses() {
    initalResponses = widget.questionnaire!.questions
        .map((element) => element.type == QuestionType.qcm ? [] : "")
        .toList();
  }
}

class Score extends StatelessWidget {
  const Score({
    super.key,
    required this.questionnaire,
    required this.points,
  });

  final Questionnaire questionnaire;
  final double points;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: BlurryContainer(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(.7),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              EColumn(crossAxisAlignment: CrossAxisAlignment.center, children: [
            12.h,
            EText(
              questionnaire.title.toUpperCase(),
              align: TextAlign.center,
              color: Colors.white,
              size: 22,
            ),
            Image(
              image: AssetImage(Assets.icons("diamant.png")),
              height: 55,
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
                    "/${questionnaire.questions.length}",
                    color: const Color.fromARGB(255, 255, 255, 255),
                    size: 24,
                  ),
                )
              ],
            ),
            9.h,
            ETextRich(textSpans: [
              ETextSpan(text: "NB:", color: Colors.amber),
              ETextSpan(
                  text: "Les questions ouvertes seront notées manuellement.",
                  color: Colors.white)
            ]),
            9.h,
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
      ),
    );
  }
}
