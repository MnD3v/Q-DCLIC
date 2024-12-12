// // ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
// import 'package:immobilier_apk/scr/presentation/controllers_bindings/bindings/inital_binging.dart';
// import 'package:immobilier_apk/scr/presentation/views/home/home_page.dart';
// import 'package:immobilier_apk/scr/config/app/export.dart';

// class ResetPassword extends StatelessWidget {
//   ResetPassword({super.key, required this.utilisateur});
//   Utilisateur utilisateur;

//   var passvisible_1 = true.obs;
//   var passvisible_2 = true.obs;
//   var repeatPass = "";
//   var pass = "";

//   @override
//   Widget build(BuildContext context) {
//     return EScaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(9.0),
//         child: EColumn(children: [
//           44.h,
//           Center(
//               child: EText('Reinitialisation',
//                   size: 32,
//                   color: AppColors.color500,
//                   weight: FontWeight.bold)),
//           32.h,
//           Obx(
//             () => UnderLineTextField(
//               phoneScallerFactor: phoneScallerFactor,
//               initialValue: pass,
//               onChanged: (value) {
//                 pass = value;
//               },
//               // number: true,
//               label: "Entrez un mot de passe",
//               pass: passvisible_1.value,
//               suffix: InkWell(
//                 onTap: () {
//                   passvisible_1.value = !passvisible_1.value;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                       passvisible_1.value
//                           ? CupertinoIcons.eye_slash_fill
//                           : CupertinoIcons.eye_fill,
//                       color: AppColors.textColor),
//                 ),
//               ),
//             ),
//           ),
//           12.h,
//           Obx(
//             () => UnderLineTextField(
//               phoneScallerFactor: phoneScallerFactor,
//               initialValue: repeatPass,
//               onChanged: (value) {
//                 repeatPass = value;
//               },
//               // number: true,
//               label: "Repetez votre mot de passe",
//               pass: passvisible_2.value,
//               suffix: InkWell(
//                 onTap: () {
//                   passvisible_2.value = !passvisible_2.value;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                       passvisible_2.value
//                           ? CupertinoIcons.eye_slash_fill
//                           : CupertinoIcons.eye_fill,
//                       color: AppColors.textColor),
//                 ),
//               ),
//             ),
//           ),
//           24.h,
//           SimpleButton(
//             width: 160,
//             onTap: () async {
//               if (pass.length < 6 || pass != repeatPass) {
//                 resetProblemesDialog();
//                 return;
//               }
//               loading();

//               var user = FirebaseAuth.instance.currentUser;

//               AuthCredential credential = EmailAuthProvider.credential(
//                   email: "${utilisateur.telephone}@gmail.com", password: pass);

//               user?.reauthenticateWithCredential(credential);

//               await user?.updatePassword(pass);

//               Utilisateur.setUser(utilisateur.copyWith(password: pass));
//               Get.off(HomePage(),
//                   binding: InitialBinding(),
//                   transition: Transition.rightToLeftWithFade,
//                   duration: 333.milliseconds);
//             },
//             text: 'Enregistrer',
//           )
//         ]),
//       ),
//     );
//   }

//   resetProblemesDialog() {
//     return Custom.showDialog(Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(21.0),
//         child: EColumn(
//           children: [
//             Center(
//               child: EText(
//                 'Problemes',
//                 size: 25,
//                 color: AppColors.color500,
//                 weight: FontWeight.bold,
//               ),
//             ),
//             12.h,
//             12.h,
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
