import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/widgets/questionnaire_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';

import 'package:lottie/lottie.dart';

class AllQuizes extends StatelessWidget {
  final Utilisateur user;
  AllQuizes({super.key, required this.user});

  var questionnaires = <Questionnaire>[];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;
      return EScaffold(
        appBar: AppBar(
          title: EText("Informations Complete", size: 24, weight: FontWeight.bold,),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (DB.waiting(snapshot)) {
                return ECircularProgressIndicator();
              }
              return AnimatedSwitcher(
                duration: 666.milliseconds,
                child: questionnaires.isEmpty
                    ? Empty(
                              constraints: constraints,
                            )
                    : DynamicHeightGridView(
                        physics: BouncingScrollPhysics(),
                        key: Key(questionnaires.length.toString()),
                        itemCount: questionnaires.length,
                        crossAxisCount: crossAxisCount.toInt() <= 0
                            ? 1
                            : crossAxisCount.toInt(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        builder: (ctx, index) {
                          var questionnaire = questionnaires[index];
                    

                          var pointsGagne =
                              questionnaire.maked.containsKey(user.telephone_id)
                                  ? questionnaire
                                      .maked[user.telephone_id]!.pointsGagne
                                  : 0.0;
                          return Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              QuestionnaireCard(
                                idUser: user.telephone_id,
                                  justUserInfos: true,
                                  navigationId: 0,
                                  dejaRepondu: true.obs,
                                  questionnaire: questionnaire,
                                  width: width),
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Row(
                                  children: [
                                    EText(
                                      pointsGagne.toStringAsFixed(2),
                                      font: Fonts.sevenSegment,
                                      size: 34,
                                      color: Colors.greenAccent,
                                    ),
                                    EText(
                                      " (${(100 * (pointsGagne / questionnaire.questions.length)).toStringAsFixed(2)})%",
                                      size: 20,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
              );
            }),
      );
    });
  }

  getData() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .orderBy(
          "date",
        )
        .limit(40)
        .get();
    questionnaires.clear();
    for (var element in q.docs) {
      questionnaires.add( await Questionnaire.fromMap(element.data(), classe: user.classe!));
    }
  }
}
