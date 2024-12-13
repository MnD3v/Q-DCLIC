import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/widgets/fl_charte.dart';

class Evolution extends StatelessWidget {
  Evolution({super.key});


  final user = Utilisateur.currentUser.value!;
  var points = <double>[];
  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        title: EText("Mon compte", size: 24, weight: FontWeight.bold,),
      ),
        body: Center(
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (DB.waiting(snapshot)) {
              return ECircularProgressIndicator();
            }
            return Column(
              children: [
                LineChartSample2(
                  points: points,
                ),
                EText("Questionnaires"),

              ],
            );
          }),
    ));
  }
    getData() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .orderBy(
          "date",
        )
        .limit(10)
        .get();
    var questionnaires = <Questionnaire>[];

    q.docs.forEach((element) {
      questionnaires.add(Questionnaire.fromMap(element.data()));
    });
    points = [];
    questionnaires.forEach((element) {
      if (element.maked.containsKey(user.telephone_id)) {
        points.add(((element.maked[user.telephone_id]!.pointsGagne) /
                element.questions.length) *
            100);
      } else {
        points.add(0);
      }
    });
    print("..........");
    print(points);
    print("..........");
  }

}
