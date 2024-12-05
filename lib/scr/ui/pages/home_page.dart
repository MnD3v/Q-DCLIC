// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _initialiseResponses();
    super.initState();
  }

  var initalResponses = [];

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d1b2a),
        surfaceTintColor: Color(0xff0d1b2a),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image(
              image: AssetImage(Assets.image("question.png")),
              height: 35,
            ),
            9.w,
            Image(
              image: AssetImage(Assets.image("logo.png")),
              height: 40,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              children: [
                Image(image: AssetImage(Assets.icons("diamant.png")),height: 30,),
                3.w,
                EText(
                  "120",
                  weight: FontWeight.bold,
                  color: Colors.greenAccent,
                  size: 39,
                  font: "SevenSegment",
                ),
                3.w,
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: EText(
                    "pts",
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      color: Color(0xFF1b263b),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: EColumn(children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EText(
                "Introduction aux feuilles de style CSS".toUpperCase(),
                align: TextAlign.center,
                size: 26,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          12.h,
          ...questions.map((element) {
            var qcmResponse = RxList<String>([]);
            var qcuResponse = "".obs;
            return Container(
              width: Get.width,
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: Color(0xff0d1b2a),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: .5, color: Colors.white)),
              margin: EdgeInsets.symmetric(vertical: 6),
              child: EColumn(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: EText(
                    element.question,
                    color: Colors.amberAccent,
                    weight: FontWeight.bold,
                    size: 22,
                  ),
                ),
                DottedDashedLine(
                  height: 0,
                  width: Get.width,
                  axis: Axis.horizontal,
                  dashColor: Colors.white,
                ),
                Obx(
                  () => EColumn(
                      children: element.choix.keys.map((e) {
                    return !element.qcm
                        ? RadioListTile(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => qcuResponse.value == e
                                    ? Colors.amberAccent
                                    : Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            value: e,
                            groupValue: qcuResponse.value,
                            onChanged: (value) {
                              qcuResponse.value = value as String;
                              var index = questions.indexOf(element);
                              initalResponses[index] = qcuResponse.value;
                            },
                            title: EText(
                              element.choix[e],
                              color: Colors.white,
                            ),
                          )
                        : CheckboxListTile(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => qcmResponse.contains(e)
                                    ? Colors.amberAccent
                                    : Colors.transparent),
                            activeColor: Colors.amberAccent,
                            side: BorderSide(width: 2, color: Colors.grey),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            value: qcmResponse.contains(e),
                            onChanged: (value) {
                              qcmResponse.contains(e)
                                  ? qcmResponse.remove(e)
                                  : qcmResponse.add(e);
                              var index = questions.indexOf(element);
                              initalResponses[index] = qcmResponse.value;
                            },
                            title: EText(
                              element.choix[e],
                              color: Colors.white,
                            ),
                          );
                  }).toList()),
                )
              ]),
            );
          }).toList(),
          12.h,
          SimpleButton(
            radius: 12,
            color: const Color.fromARGB(255, 0, 114, 59),
            onTap: () {
              var points = 0.0;
              print(initalResponses);
              for (var i = 0; i < questions.length; i++) {
                var currentQuestion = questions[i];
                if (currentQuestion.qcm) {
                  for (var element in initalResponses[i] as List) {
                    if (currentQuestion.reponse.contains(element)) {
                      points += 1 / (currentQuestion.reponse as List).length;
                    } else {
                      points -= 1 / (currentQuestion.reponse as List).length;
                    }
                  }
                } else {
                  print("----------");
                  print(currentQuestion.reponse == initalResponses[i]);
                  print(initalResponses[i].length);
                  print(currentQuestion.reponse.length);
                  print("----------");

                  if (currentQuestion.reponse == initalResponses[i]) {
                    points += 1;
                  }
                }
              }
              Custom.showDialog(
                Dialog(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  surfaceTintColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: EColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        12.h,
                        EText("Introduction aux feuilles de style CSS".toUpperCase(),align: TextAlign.center, color: Colors.white,size: 28,),
                        Image(image: AssetImage(Assets.icons("diamant.png")), height: 60,),
                        EText("Votre score", color: Colors.white,size: 24,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EText(points.toStringAsFixed(2), font: Fonts.sevenSegment, size: 65,color: const Color.fromARGB(255, 21, 255, 0),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: EText("/"+questions.length.toString(), color:const Color.fromARGB(255, 255, 255, 255),size: 24,),
                          )
                        ],
                      ),
                      SimpleOutlineButton(
                        radius: 9,
                        color: Colors.white60,
                        onTap: (){
                        Get.back();
                      }, child: EText("Fermer", color: Colors.white54,))
                    ]),
                  ),
                )
              );
              print(points.toString() +"/"+questions.length.toString());
            },
            text: "Soumettre",
          ),
          24.h
        ]),
      ),
    );
  }

  var questions = [
    Question(
      question: "Que signifie l'acronyme CSS ?",
      choix: {
        "a": "Cascading Style Sheets",
        "b": "Creative Style System",
        "c": "Compact Style Syntax",
        "d": "Computer Style Sheets"
      },
      reponse: "a",
      qcm: false,
    ),
    Question(
      question: "Quel est le rôle principal du CSS ?",
      choix: {
        "a": "Créer la structure des pages web",
        "b": "Donner vie aux pages web en appliquant des styles",
        "c": "Gérer les interactions utilisateur",
        "d": "Programmer des fonctionnalités web"
      },
      reponse: "b",
      qcm: false,
    ),
    Question(
      question:
          "Quels sont les différents moyens d'intégrer le CSS dans un document HTML ?",
      choix: {
        "a": "Feuille de style externe",
        "b": "Balise <style> dans l'en-tête HTML",
        "c": "Styles en ligne",
        "d": "Toutes ces réponses sont fausses"
      },
      reponse: ["a", "b", "c"],
      qcm: true,
    ),
    Question(
      question:
          "Quel symbole est utilisé pour définir un sélecteur de classe ?",
      choix: {"a": "#", "b": ".", "c": "*", "d": "&"},
      reponse: "b",
      qcm: false,
    ),
    Question(
      question: "Quelle est la syntaxe correcte d'une règle CSS ?",
      choix: {
        "a": "propriété : valeur",
        "b": "propriété = valeur",
        "c": "valeur -> propriété",
        "d": "valeur : propriété"
      },
      reponse: "a",
      qcm: false,
    ),
    Question(
      question: "Quels sont les types de sélecteurs CSS ?",
      choix: {
        "a": "Sélecteurs Simples",
        "b": "Sélecteurs Combinateurs",
        "c": "Sélecteurs d'Attributs",
        "d": "Sélecteurs de Pseudo-Classe",
        "e": "Sélecteurs de Pseudo-Éléments"
      },
      reponse: ["a", "b", "c", "d", "e"],
      qcm: true,
    ),
    Question(
      question: "Qu'indique le sélecteur universel ?",
      choix: {
        "a": "Un type d'élément spécifique",
        "b": "Un élément avec une classe particulière",
        "c": "L'ensemble du document",
        "d": "Un élément avec un ID unique"
      },
      reponse: "c",
      qcm: false,
    ),
    Question(
      question: "Comment cibler un élément appartenant à plusieurs classes ?",
      choix: {
        "a": "En séparant les classes par des virgules",
        "b": "En utilisant des espaces entre les classes",
        "c": "En accolant les noms de classes sans espace",
        "d": "En utilisant le sélecteur universel"
      },
      reponse: "c",
      qcm: false,
    ),
    Question(
      question: "Quelles sont les méthodes pour définir une couleur en CSS ?",
      choix: {
        "a": "Noms de couleur",
        "b": "Codes hexadécimaux",
        "c": "Codes RGB",
        "d": "Toutes ces réponses sont fausses"
      },
      reponse: ["a", "b", "c"],
      qcm: true,
    ),
    Question(
      question: "Quelle propriété CSS contrôle la taille de la police ?",
      choix: {
        "a": "text-size",
        "b": "font-size",
        "c": "text-height",
        "d": "font-height"
      },
      reponse: "b",
      qcm: false,
    ),
  ];

  _initialiseResponses() {
    initalResponses =
        questions.map((element) => element.qcm ? [] : "").toList();
  }
}

class Question {
  String question;
  Map<String, String> choix;
  dynamic reponse;
  bool qcm;
  Question({
    required this.question,
    required this.choix,
    required this.reponse,
    required this.qcm,
  });
}
