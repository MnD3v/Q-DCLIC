// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:async';

import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/ardoise/ardoise.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/evolution.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/all_questionnaires.dart';

import 'package:immobilier_apk/scr/ui/widgets/bottom_navigation_widget.dart';

class HomePage extends StatefulWidget {
  static var totalPoints = Utilisateur.currentUser.value!.points.obs;

  static var newQuestionnaires = 0.obs;
  static var newQuestionsArdoise = 0.obs;
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initalResponses = [];

  var dejaRepondu = false.obs;

  // var id = "".obs;

  PageController pageController = PageController();

  var currentPageIndex = 0.obs;

  var loading = false.obs;

  @override
  void initState() {
    streamQuestionsAndUpdate();
    streamQuestionnairesAndUpdate();
    super.initState();
  }

  var user = Utilisateur.currentUser.value!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 700.0 ? 700.0 : constraints.maxWidth;

      return EScaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background900,
          surfaceTintColor: AppColors.background900,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                child: Image(
                  image: AssetImage(Assets.image("logo.png")),
                  height: 35,
                ),
              ),
            ],
          ),
          actions: [
            StreamBuilder(
                stream: DB
                    .firestore(Collections.utilistateurs)
                    .doc(user.telephone_id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (DB.waiting(snapshot)) {
                    return ECircularProgressIndicator();
                  }
                  var user = Utilisateur.fromMap(snapshot.data!.data()!);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(Evolution());
                      },
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(Assets.icons("diamant.png")),
                            height: 20,
                          ),
                          3.w,
                          EText(
                            user.points.toStringAsFixed(2),
                            weight: FontWeight.bold,
                            color: Colors.greenAccent,
                            size: 33,
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
                    ),
                  );
                })
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            currentPageIndex.value = index;
          },
          children: [ViewAllQuestionnaires(), Ardoise(), Compte()],
        ),
        bottomNavigationBar: MBottomNavigationBar(
            ready: true.obs,
            pageController: pageController,
            currentPage: currentPageIndex),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.transparent,
        //   onPressed: () {
        //   Get.dialog(AddArdoiseQuestion());
        // }),
      );
    });
  }
}

StreamSubscription streamQuestionsAndUpdate() {
  var user = Utilisateur.currentUser.value!;

  // Téléphone de l'utilisateur actuel
  var telephone = Utilisateur.currentUser.value!.telephone_id;

  // Souscription au flux de données Firestore
  return DB
      .firestore(Collections.classes)
      .doc(user.classe)
      .collection(Collections.ardoise)
      .doc(user.classe)
      .collection(Collections.production)
      .orderBy("date", descending: true)
      .snapshots()
      .listen((snapshot) {
    // Liste des questions à mettre à jour
    List<ArdoiseQuestion> questions = [];

    // Traitement des documents reçus
    for (var element in snapshot.docs) {
      questions.add(ArdoiseQuestion.fromMap(element.data()));
    }

    // Mise à jour de `newQuestionsArdoise` avec le nombre de nouvelles questions
    HomePage.newQuestionsArdoise.value = questions
        .where((element) => !element.maked.containsKey(telephone))
        .length;
  }, onError: (error) {
    // Gestion des erreurs éventuelles
    print('Erreur lors du streaming : $error');
  });
}

StreamSubscription streamQuestionnairesAndUpdate() {
  var user = Utilisateur.currentUser.value!;

  // Téléphone de l'utilisateur actuel
  var telephone = Utilisateur.currentUser.value!.telephone_id;

  // Souscription au flux de données Firestore
  return DB
      .firestore(Collections.classes)
      .doc(user.classe)
      .collection(Collections.questionnaires)
      .doc(user.classe)
      .collection(Collections.production)
      .orderBy("date", descending: true)
      .snapshots()
      .listen((snapshot) {
    // Liste des questionnaires à mettre à jour
    List<Questionnaire> questionnaires = [];

    // Traitement des documents reçus
    waitAfter(0, () async {
      for (var element in snapshot.docs) {
        questionnaires.add(await Questionnaire.fromMap(element.data(), ));
      }
      // Mise à jour de `newQuestionnaires` avec le nombre de nouveaux questionnaires
      HomePage.newQuestionnaires.value = questionnaires
          .where((element) => !element.maked.containsKey(telephone))
          .length;
    });
  }, onError: (error) {
    // Gestion des erreurs éventuelles
    print('Erreur lors du streaming : $error');
  });
}
