// // ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
// import 'package:immobilier_apk/scr/config/app/export.dart';
// import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';

// class Inscription extends StatelessWidget {
//   Inscription({
//     super.key,
//     required this.function,
//   });

//   bool? deconnected;
//   final function;
//   Utilisateur utilisateur = Utilisateur.empty;

//   var currentRegion = Rx<String?>(null);

//   var passvisible_1 = true.obs;

//   var passvisible_2 = true.obs;

//   String repeatPass = "";

//   var isLoading = false.obs;

//   var country = "TG";

//   @override
//   Widget build(BuildContext context) {

//     var phoneScallerFactor = MediaQuery.of(context).textScaleFactor;

//     return EScaffold(
//       appBar: AppBar(
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.transparent,
//         title: const TitleText(
//           "Inscription",
//         ),
       
//       ),
//       body: Obx(
//         () => IgnorePointer(
//           ignoring: isLoading.value,
//           child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: EColumn(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     16.h,
//                     Hero(
//                       tag: "launch_icon",
//                       child: Image(
//                           image: AssetImage(Assets.icons("account_2.png")),
//                           height: 70),
//                     ),
//                     24.h,
//                     const BigTitleText(
//                       "M'inscrire",
//                     ),
//                     34.h,
//                     UnderLineTextField(
//                       label: "Votre nom",
//                       phoneScallerFactor: phoneScallerFactor,
//                       onChanged: (value) {
//                         utilisateur.nom = value;
//                       },
//                     ),
//                     10.h,
//                     UnderLineTextField(
//                       label: "Votre prénom",
//                       phoneScallerFactor: phoneScallerFactor,
//                       onChanged: (value) {
//                         utilisateur.prenom = value;
//                       },
//                     ),
//                     10.h,
//                     UnderLineTextField(
                 
//                       label: "Votre numéro de télephone",
//                       phoneScallerFactor: phoneScallerFactor,
//                       number: true,
//                       onChanged: (value) {
//                         utilisateur.telephone.numero = value;
//                       },
//                     ),
//                     10.h,
//                     Obx(
//                       () => UnderLineTextField(
//                         label: "Votre mot de passe",
//                         phoneScallerFactor: phoneScallerFactor,
//                         pass: passvisible_1.value,
//                         onChanged: (value) {
//                           utilisateur.password = value;
//                         },
//                         suffix: GestureDetector(
//                           onTap: () {
//                             passvisible_1.value = !passvisible_1.value;
//                           },
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Icon(
//                                 !passvisible_1.value
//                                     ? CupertinoIcons.eye_slash_fill
//                                     : CupertinoIcons.eye_fill,
//                                 color: AppColors.textColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                     10.h,
//                     Obx(
//                       () => UnderLineTextField(
//                         label: "Répeter votre mot de passe",
//                         phoneScallerFactor: phoneScallerFactor,
//                         pass: passvisible_2.value,
//                         onChanged: (value) {
//                           repeatPass = value;
//                         },
//                         suffix: GestureDetector(
//                           onTap: () {
//                             passvisible_2.value = !passvisible_2.value;
//                           },
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Icon(
//                                 !passvisible_2.value
//                                     ? CupertinoIcons.eye_slash_fill
//                                     : CupertinoIcons.eye_fill,
//                                 color: AppColors.textColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                     25.h,
//                     SimpleButton(
//                         width: 160,
//                         onTap: () async {
//                           FocusManager.instance.primaryFocus?.unfocus();
//                           if (IsNullString(utilisateur.nom) ||
//                               IsNullString(utilisateur.prenom) ||
//                               !GFunctions.isPhoneNumber(
//                                   country: utilisateur.telephone.indicatif,
//                                   numero: utilisateur.telephone.numero) ||
//                               utilisateur.password.length < 6 ||
//                               utilisateur.password != repeatPass) {
//                             inscriptionProblemesDialog();
//                           } else {
//                             try {
//                               isLoading.value = true;

//                               try {
//                                 await FirebaseAuth.instance
//                                     .createUserWithEmailAndPassword(
//                                   email:
//                                       "${utilisateur.telephone.numero}@gmail.com",
//                                   password: utilisateur.password,
//                                 );
//                                 utilisateur.country = country;
//                                 await Utilisateur.setUser(utilisateur);

//                                 isLoading.value = false;

//                                 Get.back();
//                                 Toasts.success(context,
//                                     description:
//                                         "Vous vous êtes connecté avec succès");
//                                         Utilisateur.refreshToken();
//                                 waitAfter(1000, () {
//                                   function();
//                                 });
//                               } on FirebaseAuthException catch (e) {
//                                 if (e.code == 'email-already-in-use') {
//                                   Custom.showDialog(
//                                     const WarningWidget(
//                                       message:
//                                           "Numero déjà utilisé. Veuillez vous connecter !",
//                                     ),
//                                   );
//                                   isLoading.value = false;
//                                 }
//                               }
//                             } on Exception {
//                               Custom.showDialog(const WarningWidget(
//                                 message:
//                                     "Une erreur s'est produite. veuillez verifier votre connexion internet",
//                               ));
//                               isLoading.value = false;
//                             }
//                           }
//                         },
//                         child: Obx(
//                           () => isLoading.value
//                               ? const SizedBox(
//                                   height: 25,
//                                   width: 25,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 1.3,
//                                   ))
//                               : const EText(
//                                   "Ajouter",
//                                   weight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                         ))
//                   ])),
//         ),
//       ),
//     );
//   }

//   inscriptionProblemesDialog() {
//     return Custom.showDialog(Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(21.0),
//         child: EColumn(
//           children: [
//             Center(
//               child: EText(
//                 'Problèmes',
//                 size: 25,
//                 color: AppColors.color500,
//                 weight: FontWeight.bold,
//               ),
//             ),
//             12.h,
//             12.h,
//             IsNullString(utilisateur.nom)
//                 ? const WarningElement(
//                     label: 'Veuillez saisir votre nom',
//                   )
//                 : 0.h,
//             IsNullString(utilisateur.prenom)
//                 ? const WarningElement(
//                     label: 'Veuillez saisir votre prénom',
//                   )
//                 : 0.h,
//             !GFunctions.isPhoneNumber(
//                     country: utilisateur.telephone.indicatif,
//                     numero: utilisateur.telephone.numero)
//                 ? const WarningElement(
//                     label: 'Veuillez saisir un numero valide',
//                   )
//                 : 0.h,
//             utilisateur.password.length < 6
//                 ? const WarningElement(
//                     label:
//                         'Le mot de passe doit etre superieur ou égale à 6 caractères',
//                   )
//                 : 0.h,
//             utilisateur.password != repeatPass
//                 ? const WarningElement(
//                     label: 'Les mots de passe doivent être identiques',
//                   )
//                 : 0.h,
//             6.h,
//             SimpleButton(
//               onTap: () {
//                 Get.back();
//               },
//               text: 'OK',
//               smallHeight: true,
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }
