// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dotted_line/dotted_line.dart';

import 'dart:async';

import 'package:immobilier_apk/scr/config/app/export.dart';

import 'package:immobilier_apk/scr/ui/pages/home/ardoise/ardoise.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/compte_view.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/evolution.dart';
import 'package:immobilier_apk/scr/ui/pages/home/questionnaires/all_questionnaires.dart';
import 'package:http/http.dart' as http;

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
    streamPresenceVerification();
    super.initState();
  }

  var user = Utilisateur.currentUser.value!;

  var verification = false.obs;

  var presenceAnimation = false.obs;

  var presenceVerifcationLoading = false.obs;

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
            Obx(() => AnimatedSwitcher(
                  duration: 666.milliseconds,
                  child: verification.value
                      ? presenceVerifcationLoading.value
                          ? ECircularProgressIndicator(
                              height: 20,
                            )
                          : GestureDetector(
                              onTap: () async {
                                presenceVerifcationLoading.value = true;
                                var q = await DB
                                    .firestore(Collections.classes)
                                    .doc(user.classe)
                                    .collection(Collections.presence)
                                    .doc("Verification")
                                    .get();

                                var date = q["date"];
                                int heures = q["heures"];
                                var publicIp = q["ip"];
                                var code = q["code"];
                                var myIp = await getPublicIP();
                                if (myIp != publicIp) {
                                  Toasts.error(context,
                                      description:
                                          "Veuillez vous connecter au réseau du centre de formation");
                                  return;
                                }
                                var myCode = "";
                                await Get.dialog(Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: EColumn(children: [
                                      EText(
                                        "Code",
                                        size: 28,
                                      ),
                                      9.h,
                                      ETextField(
                                          onChanged: (value) {
                                            myCode = value;
                                          },
                                          phoneScallerFactor:
                                              phoneScallerFactor),
                                      12.h,
                                      SimpleButton(
                                        onTap: () async {
                                          if (myCode != code) {
                                            Toasts.error(context,
                                                description: "Code incorrect");
                                            return;
                                          }
                                          Get.back();

                                          user.heuresTotal += heures;
                                          Utilisateur.setUser(user);
                                          verification.value = false;
                                          presenceVerifcationLoading.value =
                                              false;
                                          await DB
                                              .firestore(Collections.classes)
                                              .doc(user.classe)
                                              .collection(Collections.presence)
                                              .doc(date)
                                              .collection(Collections.presence)
                                              .doc(user.telephone_id)
                                              .set({"heures": heures});
                                          Toasts.success(context,
                                              description:
                                                  "Verification effectuée avec succès");
                                        },
                                        text: "Continuer",
                                      )
                                    ]),
                                  ),
                                ));
                                presenceVerifcationLoading.value = false;
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.greenAccent)),
                                child: AnimatedContainer(
                                  onEnd: () {
                                    presenceAnimation.value =
                                        !presenceAnimation.value;
                                  },
                                  duration: 666.milliseconds,
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: presenceAnimation.value
                                          ? Colors.greenAccent
                                          : Colors.transparent),
                                ),
                              ),
                            )
                      : 0.h,
                )),
            12.w,
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

  StreamSubscription streamPresenceVerification() {
    var user = Utilisateur.currentUser.value!;

    // Téléphone de l'utilisateur actuel
    var telephone = Utilisateur.currentUser.value!.telephone_id;

    // Souscription au flux de données Firestore
    return DB
        .firestore(Collections.classes)
        .doc(user.classe)
        .collection(Collections.presence)
        .doc("Verification")
        .snapshots()
        .listen((snapshot) {
      waitAfter(555, () async {
        var q = await DB
            .firestore(Collections.classes)
            .doc(user.classe)
            .collection(Collections.presence)
            .doc("Verification")
            .get();

        var date = q["date"];
        var qPresence = await DB
            .firestore(Collections.classes)
            .doc(user.classe)
            .collection(Collections.presence)
            .doc(date)
            .collection(Collections.presence)
            .doc(user.telephone_id)
            .get();
        if (qPresence.exists) {
          verification.value = false;
        } else {
          verification.value = snapshot.data()!["verification"];
          waitAfter(555, () {
            presenceAnimation.value = !presenceAnimation.value;
          });
        }
      });

      print("88888888888888888888888888888888888");
      print(verification.value);
      print("88888888888888888888888888888888888");
    }, onError: (error) {
      // Gestion des erreurs éventuelles
      print('Erreur lors du streaming : $error');
    });
  }

  Future<String> getPublicIP() async {
    try {
      final response =
          await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("********************************************");
        print(data['ip']);
        print("********************************************");

        return data['ip']; // Adresse IP publique
      }
      return 'Erreur : Impossible de récupérer l\'adresse IP';
    } catch (e) {
      return 'Erreur : $e';
    }
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
        questionnaires.add(await Questionnaire.fromMap(
          element.data(),
        ));
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
