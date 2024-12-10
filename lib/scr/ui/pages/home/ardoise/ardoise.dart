import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/ardoise_question.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/widgets/ardoise_card.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class Ardoise extends StatelessWidget {
  Ardoise({super.key});

  var questions = <ArdoiseQuestion>[];
              var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DB
            .firestore(Collections.classes)
            .doc(user.classe)
            .collection(Collections.ardoise)
            .orderBy("date", descending: true)
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

