import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:lottie/lottie.dart';

class ViewAllQuestionnaires extends StatelessWidget {
  ViewAllQuestionnaires({
    super.key,
  });

  var questionnaires = Rx<List<Questionnaire>?>(null);

  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DB
            .firestore(Collections.classes)
            .doc(user.classe)
            .collection(Collections.questionnaires)
            .doc(user.classe)
            .collection(Collections.production)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (DB.waiting(snapshot)) {
            return ECircularProgressIndicator();
          }
          var user = Utilisateur.currentUser.value!;
          var telephone = user.telephone_id;

          var tempQuestionnaire = <Questionnaire>[];

          waitAfter(0, () async {
            for (var element in snapshot.data!.docs) {
              tempQuestionnaire.add(await Questionnaire.fromMap(element.data(),
                  classe: user.classe!));
            }
            print(tempQuestionnaire);
            questionnaires.value = tempQuestionnaire;
          });

          return LayoutBuilder(builder: (context, constraints) {
            return LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width / 400;
              return Obx(
                () => questionnaires.value.isNul
                    ? ECircularProgressIndicator()
                    : questionnaires.value!.isEmpty
                        ? Empty(
                            constraints: constraints,
                          )
                        : AnimatedSwitcher(
                            duration: 666.milliseconds,
                            child: DynamicHeightGridView(
                                key: Key(
                                    (questionnaires.value?.length).toString()),
                                physics: BouncingScrollPhysics(),
                                itemCount: questionnaires.value!.length,
                                crossAxisCount: crossAxisCount.toInt() <= 0
                                    ? 1
                                    : crossAxisCount.toInt(),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                builder: (ctx, index) {
                                  var questionnaire =
                                      questionnaires.value![index];
                                  var dejaRepondu = questionnaire.maked
                                      .containsKey(telephone)
                                      .obs;
                                  return QuestionnaireCard(
                                      dejaRepondu: dejaRepondu,
                                      questionnaire: questionnaire);
                                }),
                          ),
              );
            });
          });
        });
  }
}

class QuestionnaireCard extends StatelessWidget {
  const QuestionnaireCard({
    super.key,
    required this.dejaRepondu,
    required this.questionnaire,
  });

  final RxBool dejaRepondu;
  final Questionnaire questionnaire;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ViewQuestionnaire(
          dejaRepondu: dejaRepondu,
          questionnaire: questionnaire,
        ));
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Obx(
          () => Container(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
            decoration: BoxDecoration(
                color:
                    dejaRepondu.value ? Colors.transparent : Color(0xffFCEDC2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24)),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.image("noise.png")),
                    fit: BoxFit.cover),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width - 95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EText(
                          questionnaire.title,
                          color: dejaRepondu.value
                              ? Colors.white
                              : const Color.fromARGB(255, 61, 61, 61),
                          size: 22,
                        ),
                        6.h,
                        EText(
                          questionnaire.date
                              .split(" ")[0]
                              .split("-")
                              .reversed
                              .join("-"),
                          color: dejaRepondu.value
                              ? const Color.fromARGB(255, 255, 190, 116)
                              : const Color.fromARGB(255, 61, 61, 61),
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                        6.h,
                        Obx(
                          () => SimpleButton(
                            width: dejaRepondu.value ? 90 : 122,
                            color: dejaRepondu.value
                                ? Colors.white12
                                : Color(0xffFFBB00),
                            height: 35,
                            onTap: () {
                              Get.to(ViewQuestionnaire(
                                dejaRepondu: dejaRepondu,
                                questionnaire: questionnaire,
                              ));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, top: 3),
                                    child: EText(
                                      dejaRepondu.value ? "Voir" : "Demarer",
                                      color: dejaRepondu.value
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 53, 53, 53),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right_rounded,
                                  color: dejaRepondu.value
                                      ? Colors.white
                                      : Color.fromARGB(255, 53, 53, 53),
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: dejaRepondu.value ? Colors.white : Colors.black,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
