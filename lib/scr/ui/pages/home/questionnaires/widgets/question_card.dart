import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/repository/const.dart';

import 'package:immobilier_apk/scr/ui/pages/home/ardoise/widgets/ardoise_card.dart';

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
    var idUser = Utilisateur.currentUser.value!.telephone_id;
    var qctResponse = "".obs;
    if (dejaRepondu.value) {
      if (element.type == QuestionType.qcm) {
        qcmResponse.value =
            (questionnaire!.maked[idUser]!.response[index] as List)
                .map((element) => element.toString())
                .toList();
      } else if (element.type == QuestionType.qcu) {
        qcuResponse.value = questionnaire!.maked[idUser]!.response[index];
      } else {
        qctResponse.value = questionnaire!.maked[idUser]!.response[index];
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
 
      final width = constraints.maxWidth;
      return Container(
        width: width,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 2, 17, 58),
            borderRadius: BorderRadius.circular(12),
            border: Border(
                top: BorderSide(
              width: 6,
              color: colorMap[element.question.length%50]??Colors.pinkAccent
            ))),
        margin: EdgeInsets.symmetric(vertical: 6),
        child: EColumn(children: [
          Container(
            padding: EdgeInsets.all(6),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
                  child: ETextRich(
                    textSpans: [
                      ETextSpan(
                          text: "${index + 1}. ",
                          color: Colors.amber,
                          weight: FontWeight.bold),
                      ETextSpan(text: element.question, color: Colors.white60),
                    ],
                    size: 22,
                  ),
                ),
                element.image.isNotNul
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: InkWell(
                          onTap: () {
                            showImageViewer(
                                context, NetworkImage(element.image!));
                          },
                          child: EFadeInImage(
                              height: 120,
                              width: 120,
                              image: NetworkImage(element.image!)),
                        ),
                      )
                    : 0.h
              ],
            ),
          ),
          DottedDashedLine(
            height: 0,
            width: width - 4,
            axis: Axis.horizontal,
            dashColor: Colors.white54,
          ),
          element.type == QuestionType.qct
              ? Obx(
                  () => dejaRepondu.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 18),
                          child: EColumn(
                            children: [
                              EText(
                                supprimerTirets(qctResponse.value),
                                color: qctResponse.contains("--false")
                                    ? Colors.red
                                    : qctResponse.contains("--true")
                                        ? Colors.green
                                        : Colors.white,
                              ),
                              9.h,
                              EText(
                                element.reponse,
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),
                        )
                      : ETextField(
                        border: false,
                          maxLines: 6,
                          minLines: 3,
                          radius: 18,
                          placeholder: "Saisissez votre reponse",
                          onChanged: (value) {
                            initalResponses[index] = "$value--none";
                            qctResponse.value = value;
                          },
                          phoneScallerFactor: phoneScallerFactor),
                )
              : Obx(
                  () => EColumn(
                      children: element.choix.keys.map((e) {
                    return element.type != QuestionType.qcm
                        ? IgnorePointer(
                            ignoring: dejaRepondu.value,
                            child: RadioListTile(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => qcuResponse.value == e
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
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          height: 90,
                                          width: 120,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: dejaRepondu.value &&
                                                        element.reponse == e
                                                    ? Colors.greenAccent
                                                    : dejaRepondu.value &&
                                                            initalResponses[
                                                                    index] ==
                                                                e
                                                        ? Colors.red
                                                        : Colors.white,
                                              )),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: InkWell(
                                              onTap: () {
                                                showImageViewer(
                                                    context,
                                                    NetworkImage(
                                                        element.choix[e]!),
                                                    onViewerDismissed: () {
                                                  print("dismissed");
                                                });
                                              },
                                              child: EFadeInImage(
                                                height: 120,
                                                width: 120,
                                                image: NetworkImage(
                                                    element.choix[e]!),
                                              ),
                                            ),
                                          )),
                                    )
                                  : EText(
                                      element.choix[e],
                                      color: dejaRepondu.value &&
                                              element.reponse == e
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
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => qcmResponse.contains(e)
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
                              var index =
                                  questionnaire!.questions.indexOf(element);
                              initalResponses[index] = qcmResponse.value;
                            },
                            title: isFirebaseStorageLink(element.choix[e]!)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        height: 90,
                                        width: 120,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: dejaRepondu.value &&
                                                        element.reponse
                                                            .contains(e)
                                                    ? Colors.greenAccent
                                                    : dejaRepondu.value &&
                                                            initalResponses[
                                                                    index]
                                                                .contains(e)
                                                        ? Colors.red
                                                        : Colors.white)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: InkWell(
                                            onTap: () {
                                              showImageViewer(
                                                  context,
                                                  NetworkImage(
                                                      element.choix[e]!),
                                                  onViewerDismissed: () {
                                                print("dismissed");
                                              },
                                                  doubleTapZoomable: true,
                                                  backgroundColor: Colors.black,
                                                  barrierColor: Colors.black,
                                                  useSafeArea: true);
                                            },
                                            child: EFadeInImage(
                                              height: 120,
                                              width: 120,
                                              image: NetworkImage(
                                                  element.choix[e]!),
                                            ),
                                          ),
                                        )),
                                  )
                                : EText(
                                    element.choix[e],
                                    color: dejaRepondu.value &&
                                            element.reponse.contains(e)
                                        ? Colors.greenAccent
                                        : dejaRepondu.value &&
                                                initalResponses[index]
                                                    .contains(e)
                                            ? Colors.red
                                            : Colors.white,
                                  ),
                          );
                  }).toList()),
                )
        ]),
      );
    });
  }
}

String supprimerTirets(String qctResponse) {
  return qctResponse
      .replaceAll("--none", "")
      .replaceAll("--false", "")
      .replaceAll("--true", "");
}

// Color generateRandomColor() {
//   final Random random = Random();
//   return Color.fromARGB(
//     255, // Opacité fixe (complètement opaque)
//     random.nextInt(256), // Rouge (0 à 255)
//     random.nextInt(256), // Vert (0 à 255)
//     random.nextInt(256), // Bleu (0 à 255)
//   );
// }
