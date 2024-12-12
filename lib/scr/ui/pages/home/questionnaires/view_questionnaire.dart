// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';


import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';

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

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  PageController pageController = PageController();

  var loading = false.obs;

  var telephone = Utilisateur.currentUser.value!.telephone_id;

  @override
  void initState() {
    waitAfter(10, (){
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
    return  LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
        return EScaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.background,
            title: EText("Questionnaire", size: 22,),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage(Assets.icons("diamant.png")),
                      height: 20,
                    ),
                    3.w,
                    Obx(
                      () => EText(
                        totalPoints.value.toStringAsFixed(2),
                        weight: FontWeight.bold,
                        color: Colors.greenAccent,
                        size: 33,
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child:            DynamicHeightGridView(
                  physics: BouncingScrollPhysics(),
                    itemCount: widget.questionnaire.questions.length,
                 crossAxisCount: crossAxisCount.toInt() <= 0 ? 1 : crossAxisCount.toInt(),
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
                    })
            
         ),
          bottomNavigationBar:    Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () => widget.dejaRepondu.value
                      ? 0.h
                      : SimpleButton(
                          radius: 12,
                          color: const Color.fromARGB(255, 0, 114, 59),
                          onTap: () async {
                            loading.value = true;
                            var points = 0.0;
                            for (var i = 0;
                                i < widget.questionnaire.questions.length;
                                i++) {
                              var currentQuestion =
                                  widget.questionnaire.questions[i];
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
      }
    );
  }

  Future<void> saveInformations(double points) async {
    var telephone = Utilisateur.currentUser.value!.telephone_id;
    var user = Utilisateur.currentUser.value!;
    //mis a jour de la reponse de l'utilisateur
    widget.questionnaire!.maked.putIfAbsent(
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
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .doc(widget.questionnaire.id)
        .set(widget.questionnaire!.toMap());
    Utilisateur.currentUser.value!.points += points;
    totalPoints.value = Utilisateur.currentUser.value!.points;
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
        dialog: Dialog(
          backgroundColor:  Colors.transparent,
          surfaceTintColor:  Colors.transparent,
          child: BlurryContainer(
            decoration: BoxDecoration(color: Colors.black.withOpacity(.7), borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: EColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    12.h,
                    EText(
                      widget.questionnaire.title.toUpperCase(),
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
                            "/" +
                                widget.questionnaire!.questions.length.toString(),
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
          ),
        ));
  }

  // void showInputDialogForId(String _id) {
  _initialiseResponses() {
    initalResponses = widget.questionnaire!.questions
        .map((element) => element.type == QuestionType.qcm ? [] : "")
        .toList();
  }
}


