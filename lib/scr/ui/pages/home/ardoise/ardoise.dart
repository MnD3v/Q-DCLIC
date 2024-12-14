import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/ardoise/widgets/ardoise_card.dart';
import 'package:immobilier_apk/scr/ui/widgets/empty.dart';
import 'package:lottie/lottie.dart';

class Ardoise extends StatelessWidget {
  Ardoise({super.key});

  var questions = <ArdoiseQuestion>[];
  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DB
            .firestore(Collections.classes)
            .doc(user.classe)
            .collection(Collections.ardoise)
            .doc(user.classe)
            .collection(Collections.production)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (DB.waiting(snapshot)) {
            return ECircularProgressIndicator();
          }

          var telephone = Utilisateur.currentUser.value!.telephone_id;
          questions.clear();
          for (var element in snapshot.data!.docs) {
            questions.add(ArdoiseQuestion.fromMap(element.data()));
          }
          return LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width / 400;
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: questions.isEmpty
                    ? Empty(
                        constraints: constraints,
                      )
                    : AnimatedSwitcher(
                        duration: 666.milliseconds,
                        child: DynamicHeightGridView(
                            key: Key(questions.length.toString()),
                            physics: BouncingScrollPhysics(),
                            itemCount: questions.length,
                            crossAxisCount: crossAxisCount.toInt() <= 0
                                ? 1
                                : crossAxisCount.toInt(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            builder: (ctx, index) {
                              var element = questions[index];
                              var qcmResponse = RxList<String>([]);
                              var qcuResponse = "".obs;
                              var qctResponse = "".obs;

                              var dejaRepondu = false.obs;

                              dejaRepondu.value =
                                  element!.maked.keys.contains(telephone);

                              return ArdoiseQuestionCard(
                                  dejaRepondu: dejaRepondu,
                                  qctResponse: qctResponse,
                                  qcuResponse: qcuResponse,
                                  qcmResponse: qcmResponse,
                                  question: element);
                            }),
                      ));
          });
        });
  }
}
