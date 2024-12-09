import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard(
      {super.key,
      required this.index,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.questionnaire,
      required this.initalResponses,
      required this.qcmResponse,
      required this.element});
  final Question element;
  final int index;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final Questionnaire? questionnaire;
  final List initalResponses;
  final RxList<String> qcmResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Color(0xff0d1b2a),
          // borderRadius: BorderRadius.circular(18),
          border: Border.all(width: .5, color: Colors.white54)),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(
        children: [
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
                    ETextSpan(
                        text: (index + 1).toString() + ". ",
                        color: Colors.amber,
                        weight: FontWeight.bold),
                    ETextSpan(text: element.question, color: Colors.white60),
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
    element.type == QuestionType.qct
              ? Obx(()=>
                 dejaRepondu.value? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EText(element.reponse, color: Colors.greenAccent,),
                ): ETextField(
                  maxLines: 6,
                  minLines: 3,
                  placeholder: "Saisissez votre reponse",
                    onChanged: (value) {
                      initalResponses[index] = value;
                    },
                    phoneScallerFactor: phoneScallerFactor),
              )
              :    Obx(
                ()=> EColumn(
                            children: element.choix.keys.map((e) {
                          return  !(element.type == QuestionType.qcm)
                    ? IgnorePointer(
                        ignoring: dejaRepondu.value,
                        child: RadioListTile(
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              qcuResponse.value == e
                                  ? Colors.amber
                                  : Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          value: e,
                          groupValue: qcuResponse.value,
                          onChanged: (value) {
                            qcuResponse.value = value as String;
                            var index =
                                questionnaire!.questions.indexOf(element);
                            initalResponses[index] = qcuResponse.value;
                          },
                          title: isFirebaseStorageLink(element.choix[e]!)
                              ? Container(
                                  width: Get.width,
                                  alignment: Alignment.centerLeft,
                                  height: 90,
                                  child: EFadeInImage(
                                    radius: 12,
                                    image: NetworkImage(element.choix[e]!),
                                  ))
                              : EText(
                                  element.choix[e],
                                  color:
                                      dejaRepondu.value && element.reponse == e
                                          ? Colors.greenAccent
                                          : dejaRepondu.value &&
                                                  initalResponses[index] == e
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
                          var index = questionnaire!.questions.indexOf(element);
                          initalResponses[index] = qcmResponse.value;
                        },
                        title: isFirebaseStorageLink(element.choix[e]!)
                            ? Container(
                                width: Get.width,
                                alignment: Alignment.centerLeft,
                                height: 90,
                                child: EFadeInImage(
                                  radius: 12,
                                  image: NetworkImage(element.choix[e]!),
                                ))
                            : EText(
                                element.choix[e],
                                color: dejaRepondu.value &&
                                        element.reponse.contains(e)
                                    ? Colors.greenAccent
                                    : dejaRepondu.value &&
                                            initalResponses[index].contains(e)
                                        ? Colors.red
                                        : Colors.white,
                              ),
                      );
                        }).toList()),
              )
      ]),
    );
  }
}
