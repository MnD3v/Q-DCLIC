import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/inscription.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/widgets/scaffold.dart';

// ignore: must_be_immutable
class Connexion extends StatelessWidget {
  Connexion({
    super.key,
  });
  String telephone = '';

  String pass = '';

  var passvisible = false.obs;

  var isLoading = false.obs;

  var country = "TG";

  @override
  Widget build(BuildContext context) {
    var phoneScallerFactor = MediaQuery.of(context).textScaleFactor;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 700.0 ? 700.0 : constraints.maxWidth;

        return EScaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: EScaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  title: const TitleText(
                    "Connexion",
                  ),
                  actions: [TextButton(onPressed: (){Get.to(Inscription(function: (){}));}, child: EText("Inscription"))],
                ),
                body: Obx(
                  () => IgnorePointer(
                    ignoring: isLoading.value,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: EColumn(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Hero(
                                tag: "launch_icon",
                                child: Image(
                                    image: AssetImage(Assets.image("logo.png")),
                                    height: 70),
                              ),
                              25.h,
                              const BigTitleText(
                                'Connectez-vous',
                              ),
                              18.h,
                              UnderLineTextField(
                                phoneScallerFactor: phoneScallerFactor,
                                label: "Numero de téléphone",
                                onChanged: (value) {
                                  telephone = value;
                                },
                                number: true,
                              ),
                              12.h,
                              Obx(
                                () => UnderLineTextField(
                                  phoneScallerFactor: phoneScallerFactor,
                                  initialValue: pass,
                                  onChanged: (value) {
                                    pass = value;
                                  },
                                  pass: passvisible.value ? false : true,
                                  label: "Mot de passe",
                                  suffix: InkWell(
                                    onTap: () {
                                      passvisible.value = !passvisible.value;
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 9.0),
                                      child: Icon(
                                          passvisible.value
                                              ? CupertinoIcons.eye_slash_fill
                                              : CupertinoIcons.eye_fill,
                                          color: AppColors.textColor),
                                    ),
                                  ),
                                ),
                              ),
                              24.h,
                              SimpleButton(
                              radius: 12,
                                color: const Color.fromARGB(255, 0, 114, 59),
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (!GFunctions.isPhoneNumber(
                                     numero: telephone)) {
                                      Toasts.error(context,
                                          description: "Entrez un numero valide");
                                      return;
                                    }
                                    if (pass.length < 6) {
                                      Toasts.error(context,
                                          description:
                                              "Le mot de passe doit contenir aumoins 6 caracteres");
                                      return;
                                    }
                          
                                    isLoading.value = true;
                                    try {
                                      var q = await DB
                                          .firestore(Collections.utilistateurs)
                                          .doc(telephone)
                                          .get();
                                      if (q.exists) {
                                        var utilisateur = Utilisateur.fromMap(q.data()!);
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: "$telephone@gmail.com",
                                                  password: pass);
                                          Utilisateur.currentUser.value = utilisateur;
                          
                                          isLoading.value = false;
                          
                                          Get.off(HomePage());
                                          Toasts.success(context,
                                              description:
                                                  "Vous vous êtes connecté avec succès");
                                          Utilisateur.refreshToken();
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == "network-request-failed") {
                                            isLoading.value = false;
                          
                                            Custom.showDialog(
                                                barrierColor: Colors.white24,
                                                dialog: const WarningWidget(
                                                  message:
                                                      'Echec de connexion.\nVeuillez verifier votre connexion internet',
                                                ));
                                          } else if (e.code == 'invalid-credential') {
                                            isLoading.value = false;
                          
                                            Custom.showDialog(
                                                barrierColor: Colors.white24,
                                                dialog: const WarningWidget(
                                                  message: 'Mot de passe incorrect',
                                                ));
                                          }
                                        }
                                      } else {
                                        isLoading.value = false;
                                        Custom.showDialog(
                                          barrierColor: Colors.white24,
                                          dialog: const WarningWidget(
                                            message:
                                                'Pas de compte associé à ce numero. Veuillez creer un compte',
                                          ),
                                        );
                                      }
                                    } on Exception {
                                      isLoading.value = false;
                                      Custom.showDialog(
                                          barrierColor: Colors.white24,
                                          dialog: const WarningWidget(
                                            message:
                                                "Une erreur s'est produite. veuillez verifier votre connexion internet",
                                          ));
                                    }
                                  },
                                  width: 160,
                                  child: Obx(
                                    () => isLoading.value
                                        ? const SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 1.3,
                                            ))
                                        : const EText(
                                            'Se connecter',
                                            color: Colors.white,
                                          ),
                                  )),
                              // TextButton(
                              //   onPressed: () {
                              //     forgotPassword(context);
                              //   },
                              //   child: EText('Mot de passe oublié ?',
                              //       color: AppColors.color500,
                              //       weight: FontWeight.w600,
                              //       size: 20),
                              // ),
                            ])),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void forgotPassword(context) async {
    if (GFunctions.isPhoneNumber(numero: telephone)) {
      try {
        var q =
            await DB.firestore(Collections.utilistateurs).doc(telephone).get();
        if (q.exists) {
          isLoading.value = true;
          await Utilisateur.getUser(telephone);

          var utilisateur = Utilisateur.fromMap(q.data()!);

          var auth = FirebaseAuth.instance;

          await auth.verifyPhoneNumber(
            phoneNumber: utilisateur.telephone_id,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              isLoading.value = false;

              Custom.showDialog(
                  barrierColor: Colors.white24,
                  dialog: const WarningWidget(
                    message:
                        'Erreur lors de la verification du numero, veuillez réessayer plus tard',
                  ));
            },
            codeSent: (String verificationId, int? resendToken) async {
              isLoading.value = false;

              // Get.to(Verification(
              //     verificationId: verificationId, utilisateur: utilisateur));
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        } else {
          isLoading.value = false;

          Custom.showDialog(
              barrierColor: Colors.white24,
              dialog: const WarningWidget(
                message:
                    'Pas de compte associé à ce numero. veuillez creer un compte',
              ));
        }
      } on Exception {
        isLoading.value = false;

        Custom.showDialog(
            barrierColor: Colors.white24,
            dialog: const WarningWidget(
              message:
                  "Une erreur s'est produite. veuillez verifier votre connexion internet",
            ));
      }
    } else {
      Toasts.error(
        context,
        description: "Entrez un numero valide",
      );
    }
  }
}
