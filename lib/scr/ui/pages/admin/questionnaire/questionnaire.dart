import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/data/repository/const.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class CreateQuestionnaire extends StatelessWidget {
  CreateQuestionnaire({super.key});

  var questions = RxList<Question>();

  var titre = "";
  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: EText(
          "Questionnaire",
          color: Colors.amber,
          size: 24,
          weight: FontWeight.bold,
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: EColumn(
            children: [
              EText("Titre du questionnaire"),
              ETextField(
                  placeholder: "Saisissez le questionnaire",
                  onChanged: (value) {
                    titre = value;
                  },
                  phoneScallerFactor: phoneScallerFactor),
              12.h,
              Column(
                  children: questions.value.map((element) {
                var index = questions.indexOf(element);
                var initalResponses = questions
                    .map(
                        (element) => element.type == QuestionType.qcm ? [] : "")
                    .toList();
                return QuestionCard(
                  dejaRepondu: false.obs,
                  element: element,
                  index: index,
                  initalResponses: initalResponses,
                  qcmResponse: RxList(),
                  qcuResponse: RxString(""),
                  questionnaire: Questionnaire(
                      id: "",
                      date: DateTime.now().toString(),
                      title: "title",
                      maked: {},
                      questions: questions),
                );
              }).toList()),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.dialog(AddQuestion(
            questions: questions,
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.black,
              ),
              EText(
                "Ajouter une question",
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SimpleButton(
          radius: 3,
          onTap: () async {
            if (titre.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Veuillez saisir le titre du questionnaire");
              return;
            }
            if (questions.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Veuillez ajouter au moin une question");
              return;
            }

            var q = await DB.firestore(Collections.utils).doc("lastID").get();
            var lastIDKey = q.data()!["lastID"];
            print(lastIDKey);
            var id = ids[lastIDKey];

            var questionnaire = Questionnaire(
                id: id!,
                date: DateTime.now().toString(),
                title: titre,
                maked: {},
                questions: questions.value);

            DB
                .firestore(Collections.classes)
                .doc("Classe 1")
                .collection(Collections.questionnaires)
                .doc(id!)
                .set(questionnaire.toMap());
            lastIDKey += 1;
            await DB
                .firestore(Collections.utils)
                .doc("lastID")
                .set({"lastID": lastIDKey});
          },
          child: EText(
            "Enregistrer",
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
