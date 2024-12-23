import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/widgets/just_view_questinnaire_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:immobilier_apk/scr/ui/widgets/fl_charte.dart';
import 'package:lottie/lottie.dart';

class Evolution extends StatelessWidget {
  Evolution({super.key});

  final user = Utilisateur.currentUser.value!;
  var points = <double>[];

  var questionnaires = Rx<List<Questionnaire>?>(null);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount =
          (width / 400).toInt() <= 0 ? 1 : (width / 400).toInt();
      return EScaffold(
          appBar: AppBar(
            title: EText(
              "Mon Evolution",
              size: 24,
              weight: FontWeight.bold,
            ),
          ),
          body: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EColumn(
                    children: [
                      50.h,
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 700),
                        child: LineChartSample2(
                          points: points,
                        ),
                      ),
                      12.h,
                         Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: EColumn(
                                      children: [
                                        ETextRich(textSpans: [
                                          ETextSpan(
                                              text: "Axe X: ",
                                              color: Colors.pinkAccent,
                                              weight: FontWeight.bold,
                                              size: 22),
                                          ETextSpan(
                                            text: "Le numero du questionnaire",
                                            weight: FontWeight.bold,
                                          )
                                        ]),
                                        ETextRich(textSpans: [
                                          ETextSpan(
                                              text: "Axe Y: ",
                                              color: Colors.pinkAccent,
                                              weight: FontWeight.bold,
                                              size: 22),
                                          ETextSpan(
                                            text: "Le Pourcentage de réussite",
                                            weight: FontWeight.bold,
                                          )
                                        ]),
                                        24.h,
                                        EText("Questionnaires", size: 24, weight: FontWeight.bold,)
                                      ],
                                    ),
                                  ),
                      Obx(
                        () => questionnaires.value.isNul
                            ? ECircularProgressIndicator()
                            : questionnaires.value!.isEmpty
                                ? Empty(
                                    constraints: constraints,
                                  )
                                : SizedBox(
                                    height: max(
                                            (crossAxisCount ~/
                                                questionnaires.value!.length),
                                            1) * questionnaires.value!.length *
                                        165,
                                    child: DynamicHeightGridView(
                                        physics: BouncingScrollPhysics(),
                                        key: Key(questionnaires.value!.length
                                            .toString()),
                                        itemCount: questionnaires.value!.length,
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        builder: (ctx, index) {
                                           //pour que le dernier entré soit le premier affiché
                                          var questionnaire =
                                              questionnaires.value![
                                                  questionnaires.value!.length -
                                                      index -
                                                      1];
                                                          //pour que le dernier entré soit le premier affiché


                                          var pointsGagne = questionnaire.maked
                                                  .containsKey(
                                                      user.telephone_id)
                                              ? questionnaire
                                                  .maked[user.telephone_id]!
                                                  .pointsGagne
                                              : 0.0;
                                          return Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              JustViewQuestionnaireCard(
                                                  idUser: user.telephone_id,
                                                  justUserInfos: true,
                                                  navigationId: 0,
                                                  dejaRepondu: true.obs,
                                                  questionnaire: questionnaire,
                                                  width: width),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(32.0),
                                                child: Row(
                                                  children: [
                                                    EText(
                                                      pointsGagne
                                                          .toStringAsFixed(2),
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
                                  ),
                      ),
                    ],
                  ),
                );
              }));
    });
  }

  getData() async {
    var q = await DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.questionnaires)
        .doc(user.classe)
        .collection(Collections.production)
        .orderBy(
          "date",
        )
        .get();
    var tempQuestionnaires = <Questionnaire>[];

    for (var element in q.docs) {
      tempQuestionnaires.add(await Questionnaire.fromMap(element.data()));
    }
    questionnaires.value = tempQuestionnaires;
    print((1 ~/ questionnaires.value!.length));
    print(questionnaires.value!.length);
    points = [];
    for (var element in tempQuestionnaires) {
      if (element.maked.containsKey(user.telephone_id)) {
        points.add(((element.maked[user.telephone_id]!.pointsGagne) /
                element.questions.length) *
            100);
      } else {
        points.add(0);
      }
    }
    print("..........");
    print(points);
    print("..........");
  }
}
