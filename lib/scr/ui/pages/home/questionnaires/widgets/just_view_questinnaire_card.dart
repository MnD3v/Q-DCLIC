import 'package:flutter/cupertino.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/view_questionnaire.dart';

import 'package:my_widgets/data/models/questionnaire.dart';

class JustViewQuestionnaireCard extends StatelessWidget {
  JustViewQuestionnaireCard(
      {super.key,
      required this.dejaRepondu,
      required this.questionnaire,
      required this.width,
      required this.navigationId,
      this.justUserInfos,
      this.idUser,
      this.brouillon});
  final String? idUser;
  final bool? justUserInfos;
  final RxBool dejaRepondu;
  final Questionnaire questionnaire;
  final double width;
  final bool? brouillon;
  final int navigationId;

  var _loading = false.obs;
  var _delete_loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
        decoration: BoxDecoration(
            color: idUser.isNotNul && !questionnaire.maked.containsKey(idUser)
                ? Colors.red.withOpacity(.1)
                : null,
            // gradient: LinearGradient(colors: [
            //   Color.fromARGB(255, 16, 0, 43),
            //   const Color.fromARGB(255, 29, 0, 75)
            // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EText(
              questionnaire.title,
              color: Colors.white,
              size: 22,
            ),
            9.h,
            EText(
              questionnaire.date.split(" ")[0].split("-").reversed.join("-"),
              color: Colors.pinkAccent,
              size: 18,
              weight: FontWeight.bold,
            ),
            9.h,
            24.h,
    ],
        ),
      ),
    );
  }
}
