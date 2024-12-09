import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';

class ViewAllQuestionnaires extends StatelessWidget {
  ViewAllQuestionnaires({
    super.key,
  });

  var questionnaires = <Questionnaire>[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DB
            .firestore(Collections.classes)
            .doc("Classe 1")
            .collection(Collections.questionnaires)
            .get(),
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
            return GestureDetector(
              onTap: () {
                Get.to(ViewQuestionnaire(
                  questionnaire: questionnaire,
                ));
              },
              child: Opacity(
                opacity: questionnaire!.maked.keys.contains(telephone)? .6:1,
                child: Container(
                  width: Get.width,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: Color(0xff0d1b2a),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EText(
                        questionnaire.title,
                        weight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          Image(
                            image: AssetImage(Assets.icons("view_questions.png")),
                            height: 20,
                            color: Colors.greenAccent,
                          ),
                          6.w,
                          EText(questionnaire.questions.length.toString()),
                        ],
                      ),
                      3.h,
                      EText(
                        questionnaire.date,
                        size: 17,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList());
        });
  
  }
}
