import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';

class AddQuestion extends StatelessWidget {
  RxList<Question> questions;
  AddQuestion({super.key, required this.questions});
  var qcuResponse = "".obs;
  var qcmResponse = RxList<String>();

  var propositions = RxList<String>();

  var type = "qcu".obs;

  String title = "";

  var loadingImage = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: EText(
          "Ajouter une question",
          color: Colors.amber,
          size: 24,
          weight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EColumn(children: [
          EText("Ajoutez l'intitulé de la question"),
          ETextField(
              placeholder: "Saisissez l'intitulé de la question",
              onChanged: (value) {
                title = value;
              },
              phoneScallerFactor: phoneScallerFactor),
          EText("Ajouter une question"),
          Obx(
            () => Column(
              children: [
                RadioListTile(
                  fillColor: MaterialStateColor.resolveWith((states) =>
                      type.value == "qcm" ? Colors.amber : Colors.grey),
                  value: "qcm",
                  groupValue: type.value,
                  onChanged: (value) {
                    type.value = value!;
                  },
                  title: EText("QCM"),
                ),
                RadioListTile(
                  fillColor: MaterialStateColor.resolveWith((states) =>
                      type.value == "qcu" ? Colors.amber : Colors.grey),
                  value: "qcu",
                  groupValue: type.value,
                  onChanged: (value) {
                    type.value = value!;
                  },
                  title: EText("QCU"),
                ),
              ],
            ),
          ),
          9.h,
          EText("Ajouter une proposition"),
          3.h,
          Obx(
            () => Column(
              children: propositions.value.map((element) {
                var index = propositions.value.indexOf(element);
                return type.value == "qcm"
                    ? CheckboxListTile(
                        fillColor: MaterialStateColor.resolveWith((states) =>
                            qcmResponse.contains(index.toString())
                                ? Colors.amber
                                : Colors.transparent),
                        activeColor: Colors.amber,
                        side: BorderSide(width: 2, color: Colors.grey),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: qcmResponse.contains(index.toString()),
                        onChanged: (value) {
                          if (qcmResponse.contains(index.toString())) {
                            qcmResponse.remove(index.toString());
                          } else {
                            qcmResponse.add(index.toString());
                          }
                        },
                        title: isFirebaseStorageLink(element)
                            ? Container(
                                width: Get.width,
                                height: 90,
                                color: Colors.white,
                                alignment: Alignment.centerLeft,
                                child: EFadeInImage(
                                  radius: 12,
                                  image: NetworkImage(element),
                                ))
                            : EText(element),
                      )
                    : RadioListTile(
                        fillColor: MaterialStateColor.resolveWith((states) =>
                            qcuResponse.value == index.toString()
                                ? Colors.amber
                                : Colors.grey),
                        value: index.toString(),
                        groupValue: qcuResponse.value,
                        onChanged: (value) {
                          qcuResponse.value = value!;
                        },
                        title: isFirebaseStorageLink(element)
                            ? Container(
                                width: Get.width,
                                alignment: Alignment.centerLeft,
                                height: 90,
                                child: EFadeInImage(
                                  radius: 12,
                                  image: NetworkImage(element),
                                ))
                            : EText(element),
                      );
              }).toList(),
            ),
          ),
          SimpleOutlineButton(
            radius: 3,
            onTap: () {
              String proposition = "";
              Get.dialog(Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EText("Entrez la proposition"),
                        9.h,
                        ETextField(
                            placeholder: "Saisissez une proposition",
                            onChanged: (value) {
                              proposition = value;
                            },
                            phoneScallerFactor: phoneScallerFactor),
                        EText("Ou"),
                        FloatingActionButton(
                          onPressed: () {
                            ImagePicker()
                                .pickImage(
                              source: ImageSource.gallery,
                            )
                                .then(
                              (value) async {
                                loadingImage.value = true;
    
                                var link;
                                if (kIsWeb) {
                                  link = await FStorage.putData(
                                      await value!.readAsBytes());
                                } else {
                                  link =
                                      await FStorage.putFile(File(value!.path));
                                }
                                loadingImage.value = false;
                                print(link);
                                proposition = link;
                            propositions.add(proposition);

                                Get.back();
                              },
                            );
                          },
                          child: Obx(() => loadingImage.value
                              ? ECircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : 0.h),
                        ),
                        9.h,
                        SimpleButton(
                          color: Colors.greenAccent,
                          radius: 3,
                          onTap: () {
                            if (proposition.isEmpty) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Veuillez saisir une proposition valable");
                              return;
                            }
                            if (propositions.contains(proposition)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Evitez d'entrer des propositions identiques");
                              return;
                            }
                            propositions.add(proposition);
                            Get.back();
                          },
                          child: EText(
                            "Ajouter",
                            color: Colors.black,
                          ),
                        )
                      ]),
                ),
              ));
            },
            child: EText(
              "Add",
              color: Colors.amber,
            ),
          )
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SimpleButton(
            radius: 3,
            color: Colors.amber,
            onTap: () {
              if (title.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Veuillez saisir l'intitulé de la question");
                return;
              }
              if (propositions.length < 2) {
                Fluttertoast.showToast(
                    msg: "Veuillez ajouter au-moins deux questions");
                return;
              }
              var question;

              //liste en map
              Map<String, String> choix = {};
              propositions.forEach((value) {
                var index = propositions.indexOf(value);
                choix.putIfAbsent(index.toString(), () => value);
              });
              //liste en map
              if (type == "qcu") {
                if (qcuResponse.value.isEmpty) {
                  Fluttertoast.showToast(msg: "Veuillez choisir la reponse");
                  return;
                }
                question = Question(
                    question: title,
                    choix: choix,
                    reponse: qcuResponse.value,
                    qcm: false);
              } else if (type == "qcm") {
                if (qcmResponse.value.isEmpty) {
                  Fluttertoast.showToast(msg: "Veuillez choisir la reponse");
                  return;
                }
                question = Question(
                    question: title,
                    choix: choix,
                    reponse: qcuResponse.value,
                    qcm: true);
              }
              questions.add(question);
              Get.back();
            },
            child: EText(
              "Enregistrer",
              color: Colors.black,
            )),
      ),
    );
  }
}

bool isFirebaseStorageLink(String url) {
  final RegExp firebaseStorageRegex = RegExp(
    r'^https:\/\/firebasestorage\.googleapis\.com\/v0\/b\/[a-zA-Z0-9.-]+\.appspot\.com\/o\/.+\?alt=media&token=[a-zA-Z0-9-]+$',
  );
  return firebaseStorageRegex.hasMatch(url);
}
