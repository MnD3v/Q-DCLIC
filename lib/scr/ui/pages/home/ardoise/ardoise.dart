import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/ardoise_question.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class Ardoise extends StatelessWidget {
  Ardoise({super.key});

  var questions = <ArdoiseQuestion>[];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DB
            .firestore(Collections.classes)
            .doc("Classe 1")
            .collection(Collections.ardoise)
            .snapshots(),
        builder: (context, snapshot) {
          if (DB.waiting(snapshot)) {
            return ECircularProgressIndicator();
          }

          var telephone = Utilisateur.currentUser.value!.telephone.numero;
          questions.clear();
          snapshot.data!.docs.forEach((element) {
            questions.add(ArdoiseQuestion.fromMap(element.data()));
          });
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: EColumn(
                children: questions.map((element) {
              var qcmResponse = RxList<String>([]);
              var qcuResponse = "".obs;
              var qctResponse = "".obs;

              var index = questions.indexOf(element);

              var dejaRepondu = false.obs;

              dejaRepondu.value = element!.maked.keys.contains(telephone);

              return ArdoiseQuestionCard(
                  dejaRepondu: dejaRepondu,
                  qctResponse: qctResponse,
                  qcuResponse: qcuResponse,
                  qcmResponse: qcmResponse,
                  question: element);
            }).toList()),
          );
        });
  }
}

class ArdoiseQuestionCard extends StatelessWidget {
   ArdoiseQuestionCard(
      {super.key,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.qctResponse,
      required this.qcmResponse,
      required this.question});
  final ArdoiseQuestion question;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final RxString qctResponse;
  // final RxString initalResponses;
  final RxList<String> qcmResponse;

  var sendLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Color(0xff0d1b2a),
          // borderRadius: BorderRadius.circular(18),
          border: Border.all(width: .5, color: Colors.white54)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(children: [
        Container(
          padding: EdgeInsets.all(6),
          color: const Color(0xFF1b263b),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ETextRich(
                  textSpans: [
                    ETextSpan(text: question.question, color: Colors.white60),
                  ],
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        DottedDashedLine(
          height: 0,
          width: Get.width - 24,
          axis: Axis.horizontal,
          dashColor: Colors.white54,
        ),
        question.type == QuestionType.qct
            ? dejaRepondu.value
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EText(question.maked[Utilisateur.currentUser.value!.telephone.numero]!.response[0].toString()),
                )
                : ETextField(
                    maxLines: 6,
                    minLines: 3,
                    placeholder: "Saisissez votre reponse",
                    onChanged: (value) {
                      qctResponse.value = value;
                    },
                    phoneScallerFactor: phoneScallerFactor)
            : Obx(
                () => EColumn(
                    children: question.choix.keys.map((e) {
                  return !(question.type == QuestionType.qcm)
                      ? IgnorePointer(
                          ignoring: dejaRepondu.value,
                          child: RadioListTile(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => qcuResponse.value == e
                                    ? Colors.amber
                                    : Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            value: e,
                            groupValue: qcuResponse.value,
                            onChanged: (value) {
                              qcuResponse.value = value as String;
                            },
                            title: isFirebaseStorageLink(question.choix[e]!)
                                ? Container(
                                    width: Get.width,
                                    alignment: Alignment.centerLeft,
                                    height: 90,
                                    child: EFadeInImage(
                                      radius: 12,
                                      image: NetworkImage(question.choix[e]!),
                                    ))
                                : EText(
                                    question.choix[e],
                                    color: dejaRepondu.value &&
                                            question.reponse == e
                                        ? Colors.greenAccent
                                        : dejaRepondu.value &&
                                                qcuResponse.value == e
                                            ? Colors.red
                                            : Colors.white,
                                  ),
                          ),
                        )
                      : CheckboxListTile(
                          enabled: !dejaRepondu.value,
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              qcmResponse.contains(e)
                                  ? Colors.amber
                                  : Colors.transparent),
                          activeColor: Colors.amber,
                          side: BorderSide(width: 2, color: Colors.grey),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          value: qcmResponse.contains(e),
                          onChanged: (value) {
                            qcmResponse.contains(e)
                                ? qcmResponse.remove(e)
                                : qcmResponse.add(e);
                          },
                          title: isFirebaseStorageLink(question.choix[e]!)
                              ? Container(
                                  width: Get.width,
                                  alignment: Alignment.centerLeft,
                                  height: 90,
                                  child: EFadeInImage(
                                    radius: 12,
                                    image: NetworkImage(question.choix[e]!),
                                  ))
                              : EText(
                                  question.choix[e],
                                  color: dejaRepondu.value &&
                                          question.reponse.contains(e)
                                      ? Colors.greenAccent
                                      : dejaRepondu.value &&
                                              qcmResponse.value.contains(e)
                                          ? Colors.red
                                          : Colors.white,
                                ),
                        );
                }).toList()),
              ),
        Obx(
          () => dejaRepondu.value
              ? sendLoading.value? ECircularProgressIndicator(height: 19,): 0.h
              : Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      color: Colors.greenAccent,
                      onPressed: () async {
                        dejaRepondu.value = true;
                        var telephone =
                            Utilisateur.currentUser.value!.telephone.numero;
                        var user = Utilisateur.currentUser.value!;
                        var response = question.type == QuestionType.qcu
                            ? qcuResponse.value
                            : question.type == QuestionType.qcm
                                ? qcmResponse.value
                                : qctResponse.value;
                        question.maked.putIfAbsent(
                            telephone,
                            () => Maked(
                                nom: user.nom,
                                date: DateTime.now().toString(),
                                prenom: user.prenom,
                                response: [response],
                                pointsGagne: 0));
                              sendLoading.value = true;
                             await   DB.firestore(Collections.classes).doc("Classe 1").collection(Collections.ardoise).doc(question.id).set(question.toMap());
                              sendLoading.value = false;

                      },
                      icon:  Icon(Icons.check)),
                ),
        )
      ]),
    );
  }
}
