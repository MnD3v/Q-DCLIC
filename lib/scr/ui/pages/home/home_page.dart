// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/data/models/maked.dart';
import 'package:immobilier_apk/scr/data/models/question.dart';
import 'package:immobilier_apk/scr/data/models/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/ardoise/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/home/ardoise/ardoise.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/all_questionnaires.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/add_question.dart';
import 'package:immobilier_apk/scr/ui/pages/admin/questionnaire/questionnaire.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';
import 'package:immobilier_apk/scr/ui/widgets/bottom_navigation_widget.dart';
import 'package:immobilier_apk/scr/ui/widgets/question_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initalResponses = [];

  var dejaRepondu = false.obs;

  var id = "".obs;

  var totalPoints = Utilisateur.currentUser.value!.points.obs;

  PageController pageController = PageController();

  var loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d1b2a),
        surfaceTintColor: Color(0xff0d1b2a),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {

                Get.to(CreateQuestionnaire());
              },
              child: Image(
                image: AssetImage(Assets.image("logo.png")),
                height: 35,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image(
                  image: AssetImage(Assets.icons("diamant.png")),
                  height: 20,
                ),
                3.w,
                Obx(
                  () => EText(
                    totalPoints.value.toStringAsFixed(2),
                    weight: FontWeight.bold,
                    color: Colors.greenAccent,
                    size: 33,
                    font: "SevenSegment",
                  ),
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
      body: PageView(
        controller: pageController,
        children: [ViewAllQuestionnaires(), Ardoise(), Compte()],
      ),
      bottomNavigationBar: MBottomNavigationBar(
          ready: true.obs, pageController: pageController, currentPage: 0.obs),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
        Get.dialog(AddArdoiseQuestion());
      }),
    );
  }
}
