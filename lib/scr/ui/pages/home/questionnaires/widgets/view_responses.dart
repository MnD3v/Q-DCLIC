import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';


import 'package:lottie/lottie.dart';
import 'package:my_widgets/data/other/collections.dart';
import 'package:my_widgets/my_widgets.dart';

class ViewResponses extends StatelessWidget {
  final String id;
  ViewResponses({super.key, required this.id});

  var user = Utilisateur.currentUser.value!;

  Questionnaire? questionnaire;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final crossAxisCount = width / 400;

      return EScaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: EText(
              "Reponses",
              size: 24,
              weight: FontWeight.bold,
            ),
          ),
          body: StreamBuilder(
              stream: DB
                  .firestore(Collections.classes)
                  .doc(user.classe)
                  .collection(Collections.questionnaires)
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return ECircularProgressIndicator();
                }

                questionnaire = Questionnaire.fromMap(snapshot.data!.data()!);
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: questionnaire!.maked.keys.isEmpty
                        ? Lottie.asset(Assets.image("empty.json"), height: 300)
                        :    DynamicHeightGridView(
                  physics: BouncingScrollPhysics(),
                            itemCount: questionnaire!.maked.keys.length,
                            crossAxisCount: crossAxisCount.toInt() <= 0
                                ? 1
                                : crossAxisCount.toInt(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            builder: (ctx, index) {
                              var key =
                                  questionnaire!.maked.keys.toList()[index];
                              var maked = questionnaire!.maked[key];
                              return InkWell(
                                onTap: () {
                                  // Get.to(
                                  //     ViewUserQuestionnaire(
                                  //         userID: key,
                                  //         questionnaire: questionnaire!,
                                  //         dejaRepondu: true.obs),
                                  //     id: 1);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.all(6),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white12),
                                      gradient: LinearGradient(colors: [
                                        const Color(0xff0d1b2a),
                                        const Color.fromARGB(255, 29, 0, 75)
                                      ]),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.pink,
                                              child: Icon(
                                                CupertinoIcons.person,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          9.w,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              EText(
                                                  "${maked!.nom} ${maked.prenom}"),
                                              ETextRich(
                                                textSpans: [
                                                  ETextSpan(
                                                      text: maked.pointsGagne
                                                          .toStringAsFixed(2),
                                                      color:
                                                          Colors.greenAccent),
                                                  ETextSpan(
                                                    text:
                                                        "/${questionnaire!.questions.length}",
                                                    color: Colors.white,
                                                  )
                                                ],
                                                size: 30,
                                                font: Fonts.sevenSegment,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.keyboard_arrow_right_rounded)
                                    ],
                                  ),
                                ),
                              );
                            }));
              }));
    });
  }
}
