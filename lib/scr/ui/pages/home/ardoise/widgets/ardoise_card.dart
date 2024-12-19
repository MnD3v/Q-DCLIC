import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';
import 'package:my_widgets/my_widgets.dart';

class ArdoiseQuestionCard extends StatelessWidget {
  ArdoiseQuestionCard(
      {super.key,
      required this.dejaRepondu,
      required this.qcuResponse,
      required this.qctResponse,
      required this.qcmResponse,
      required this.question});
  final ArdoiseQuestion question;
  final RxBool dejaRepondu;
  final RxString qcuResponse;
  final RxString qctResponse;
  // final RxString initalResponses;
  final RxList<String> qcmResponse;

  var sendLoading = false.obs;

  var user = Utilisateur.currentUser.value!;
  @override
  Widget build(BuildContext context) {
    if (dejaRepondu.value) {
      if (question.type == QuestionType.qcm) {
        qcmResponse.value =
            (question.maked[user.telephone_id]!.response[0] as List)
                .map((element) => element.toString() as String)
                .toList();
      } else if (question.type == QuestionType.qcu) {
        qcuResponse.value = question.maked[user.telephone_id]!.response[0];
      } else {
        qctResponse.value = question.maked[user.telephone_id]!.response[0];
      }
    }
    return AnimatedContainer(
      duration: 333.milliseconds,
      padding: EdgeInsets.all(12),
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
            width: .6,
            color: question.maked
                    .containsKey(Utilisateur.currentUser.value!.telephone_id)
                ? Colors.white54
                : Colors.amber),
        color: question.maked
                .containsKey(Utilisateur.currentUser.value!.telephone_id)
            ? Colors.transparent
            : AppColors.background,
        gradient: LinearGradient(colors: [
          AppColors.background900,
          AppColors.background,
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: EColumn(children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
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
                        text: question.question,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        weight: FontWeight.bold),
                  ],
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        // DottedDashedLine(
        //   height: 0,
        //   width: Get.width - 24,
        //   axis: Axis.horizontal,
        //   dashColor: Colors.white54,
        // ),
        Obx(
          () => question.type == QuestionType.qct
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 18),
                  child: dejaRepondu.value
                      ? EColumn(
                          children: [
                            EText(
                              question
                                  .maked[Utilisateur
                                      .currentUser.value!.telephone_id]!
                                  .response[0]
                                  .toString(),
                              color: Colors.amber,
                            ),
                            9.h,
                            EText(
                              question.reponse,
                              color: Colors.greenAccent,
                            )
                          ],
                        )
                      : ETextField(
                          maxLines: 6,
                          minLines: 3,
                          radius: 12,
                          placeholder: "Saisissez votre reponse",
                          onChanged: (value) {
                            qctResponse.value = value;
                          },
                          phoneScallerFactor: phoneScallerFactor),
                )
              : EColumn(
                  children: question.choix.keys.map((e) {
                  return question.type == QuestionType.qcu
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
                            },
                            title: isFirebaseStorageLink(question.choix[e]!)
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
                                                      question.reponse == e
                                                  ? Colors.greenAccent
                                                  : dejaRepondu.value &&
                                                          question
                                                              .maked[user
                                                                  .telephone_id]!
                                                              .response
                                                              .contains(e)
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
                                                      question.choix[e]!),
                                                  onViewerDismissed: () {
                                                print("dismissed");
                                              });
                                            },
                                            child: EFadeInImage(
                                              height: 90,
                                              width: 120,
                                              radius: 12,
                                              image: NetworkImage(
                                                  question.choix[e]!),
                                            ),
                                          ),
                                        )),
                                  )
                                : Obx(
                                    () => EText(
                                      question.choix[e],
                                      color: dejaRepondu.value &&
                                              question.reponse == e
                                          ? Colors.greenAccent
                                          : dejaRepondu.value &&
                                                  qcuResponse.value == e
                                              ? Colors.red
                                              : Colors.white,
                                    ),
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
                          },
                          title: isFirebaseStorageLink(question.choix[e]!)
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
                                                      question.reponse
                                                          .contains(e)
                                                  ? Colors.greenAccent
                                                  : dejaRepondu.value &&
                                                          dejaRepondu.value &&
                                                          question
                                                              .maked[user
                                                                  .telephone_id]!
                                                              .response
                                                              .contains(e)
                                                      ? Colors.red
                                                      : Colors.white)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          onTap: () {
                                            showImageViewer(
                                                context,
                                                NetworkImage(
                                                    question.choix[e]!),
                                                onViewerDismissed: () {
                                              print("dismissed");
                                            },
                                                doubleTapZoomable: true,
                                                backgroundColor: Colors.black,
                                                barrierColor: Colors.black,
                                                useSafeArea: true);
                                          },
                                          child: EFadeInImage(
                                            height: 90,
                                            width: 120,
                                            radius: 12,
                                            image: NetworkImage(
                                                question.choix[e]!),
                                          ),
                                        ),
                                      )),
                                )
                              : Obx(
                                  () => EText(
                                    question.choix[e],
                                    color: dejaRepondu.value &&
                                            question.reponse.contains(e)
                                        ? Colors.greenAccent
                                        : dejaRepondu.value &&
                                                qcmResponse.value.contains(e)
                                            ? Colors.red
                                            : Colors.white,
                                  ),
                                ),
                        );
                }).toList()),
        ),
        Obx(
          () => Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: 666.milliseconds,
              key: UniqueKey(),
              child: sendLoading.value
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                          strokeWidth: 1.8,
                        ),
                      ),
                    )
                  : dejaRepondu.value
                      ? 0.h
                      : IconButton(
                          color: Colors.greenAccent,
                          onPressed: () async {
                            if (question.type == QuestionType.qct) {
                              if (qctResponse.value
                                  .replaceAll(" ", "")
                                  .replaceAll("\n", "")
                                  .isEmpty) {
                                Toasts.error(context,
                                    description:
                                        'Veuillez saisir la réponse à la question');
                                return;
                              }
                            }
                            var telephone =
                                Utilisateur.currentUser.value!.telephone_id;
                            var user = Utilisateur.currentUser.value!;

                            sendLoading.value = true;

                            waitAfter(3000, () async {
                              dejaRepondu.value = true;

                              var response = (question.type == QuestionType.qcu
                                  ? qcuResponse.value
                                  : question.type == QuestionType.qcm
                                      ? qcmResponse.value
                                      : qctResponse.value);
                              question.maked.putIfAbsent(
                                  telephone,
                                  () => Maked(
                                      nom: user.nom,
                                      date: DateTime.now().toString(),
                                      prenom: user.prenom,
                                      response: [response],
                                      pointsGagne: 0));
                              question.save(brouillon: false);
                              sendLoading.value = false;
                            });
                          },
                          icon: Icon(Icons.check)),
            ),
          ),
        )
      ]),
    );
  }
}

bool isFirebaseStorageLink(String url) {
  final RegExp firebaseStorageRegex = RegExp(
    r'^https:\/\/firebasestorage\.googleapis\.com\/v0\/b\/[a-zA-Z0-9.-]+\.appspot\.com\/o\/.+\?alt=media&token=[a-zA-Z0-9-]+$',
  );
  return firebaseStorageRegex.hasMatch(url);
}
