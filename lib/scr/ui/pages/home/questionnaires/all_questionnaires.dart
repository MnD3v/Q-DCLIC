import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';

class ViewAllQuestionnaires extends StatelessWidget {
  ViewAllQuestionnaires({
    super.key,
  });

  var questionnaires = <Questionnaire>[];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DB
            .firestore(Collections.classes)
            .doc("Classe 1")
            .collection(Collections.questionnaires)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (DB.waiting(snapshot)) {
            return ECircularProgressIndicator();
          }

          var telephone = Utilisateur.currentUser.value!.telephone.numero;
          questionnaires.clear();
          snapshot.data!.docs.forEach((element) {
            questionnaires.add(Questionnaire.fromMap(element.data()));
          });

          return EColumn(
              children: questionnaires.map((questionnaire) {
            var dejaRepondu = questionnaire.maked.containsKey(telephone).obs;
            return Obx(
              () => GestureDetector(
                onTap: () {
                  Get.to(ViewQuestionnaire(
                    dejaRepondu: dejaRepondu,
                    questionnaire: questionnaire,
                  ));
                },
                child: Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
                  decoration: BoxDecoration(
                      color: dejaRepondu.value
                          ? Colors.transparent
                          : Color(0xffFCEDC2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24)),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.image("noise.png")),
                          fit: BoxFit.cover),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width - 85,
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
                              EText(
                                questionnaire.date.split(" ")[0],
                                color: dejaRepondu.value
                                    ? Colors.white
                                    : const Color.fromARGB(255, 61, 61, 61),
                                size: 18,
                                weight: FontWeight.bold,
                              ),
                              // Row(
                              //   children: [
                              //     Image(
                              //       image: AssetImage(Assets.icons("view_questions.png")),
                              //       height: 20,
                              //       color: Colors.greenAccent,
                              //     ),
                              //     6.w,
                              //     EText(questionnaire.questions.length.toString()),
                              //   ],
                              // ),r
                              9.h,
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
                                            dejaRepondu.value
                                                ? "Voir"
                                                : "Demarer",
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
                          color:
                              dejaRepondu.value ? Colors.white : Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList());
        });
  }
}
