// // ignore_for_file: must_be_immutable

// import 'dart:async';

// import 'package:immobilier_apk/scr/presentation/views/signIn/reset_password.dart';
// import 'package:immobilier_apk/scr/config/app/export.dart';
// import 'package:pin_input_text_field/pin_input_text_field.dart';

// class Verification extends StatefulWidget {
//   Verification(
//       {super.key, required this.verificationId, required this.utilisateur});
//   String verificationId;
//   final Utilisateur utilisateur;

//   @override
//   State<Verification> createState() => _VerificationState();
// }

// class _VerificationState extends State<Verification> {
//   var pinController = TextEditingController();

//   var timeBeforeRessent = 60.obs;

//   @override
//   void initState() {
//     super.initState();
//     count();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   Timer? timer;
//   @override
//   Widget build(BuildContext context) {
//     return EScaffold(
//         body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: EColumn(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             EText(
//               'Verification',
//               font: Fonts.poppins,
//               weight: FontWeight.bold,
//               color: AppColors.color500,
//               size: 30,
//             ),
//             24.h,
//             const EText('Entrez le code envoyer sur le numero'),
//             6.h,
//             EText(
//               '+228 ${widget.utilisateur.telephone}',
//               weight: FontWeight.bold,
//             ),
//             38.h,
//             PinInputTextField(
//               controller: pinController,
//               onChanged: (value) async {
//                 if (value.length == 6) {
//                   loading();
//                   var auth = FirebaseAuth.instance;
//                   PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                       verificationId: widget.verificationId, smsCode: value);
//                   try {
//                     var userCredential =
//                         await auth.signInWithCredential(credential);
//                     if (userCredential.user != null) {
//                       Utilisateur.setUser(widget.utilisateur);
//                       Get.back();
//                       Get.off(ResetPassword(
//                         utilisateur: widget.utilisateur,
//                       ));
//                     } else {
//                       Get.back();
//                       Custom.showDialog(const WarningWidget(
//                           message:
//                               "Une erreur s'est produite. veuillez réessayer"));
//                     }
//                   } on Exception {
//                     Get.back();

//                     Custom.showDialog(const WarningWidget(
//                         message:
//                             "Une erreur s'est produite. veuillez réessayer"));
//                     // TODO
//                   }
//                 }
//               },
//               autoFocus: true,
//               cursor: Cursor(
//                   color: AppColors.color500,
//                   height: 20,
//                   width: 1,
//                   enabled: true),
//               decoration: BoxLooseDecoration(
//                   strokeWidth: .4,
//                   radius: const Radius.circular(12),
//                   textStyle: TextStyle(
//                       fontFamily: Fonts.poppins,
//                       color: AppColors.color500),
//                   strokeColorBuilder:
//                       FixedColorBuilder(AppColors.color500)),
//             ),
//             24.h,
//             const EText("Vous n'avez pas reçu de code ?"),
//             6.h,
//             Obx(()=>
//                TextButton(
//                 onPressed: timeBeforeRessent.value != 0
//                     ? null
//                     : () async {
//                         loading();
            
//                         pinController.clear();
//                         var auth = FirebaseAuth.instance;
            
//                         await auth.verifyPhoneNumber(
//                           phoneNumber: '+228${widget.utilisateur.telephone}',
//                           verificationCompleted:
//                               (PhoneAuthCredential credential) async {
//                             await auth.signInWithCredential(credential);
//                           },
//                           verificationFailed: (FirebaseAuthException e) {
//                             Get.back();
//                             Custom.showDialog(const WarningWidget(
//                               message:
//                                   'Erreur lors de la verification du numero, veuillez réessayer plus tard',
//                             ));
//                           },
//                           codeSent:
//                               (String verificationId, int? resendToken) async {
//                             Get.back();
//                             widget.verificationId = verificationId;
//                             timeBeforeRessent.value = 60;
//                             count();
//                             // Get.to(Verification(
//                             //     verificationId: verificationId,
//                             //     utilisateur: utilisateur));
//                           },
//                           codeAutoRetrievalTimeout: (String verificationId) {},
//                         );
//                       },
//                 child: Obx(
//                   () => EText(
//                     "Renvoyer le code",
//                     underline: true,
//                     color: timeBeforeRessent.value != 0
//                         ? Colors.grey
//                         : AppColors.color500,
//                     weight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             6.h,
//             Obx(
//               () => EText(
//                 "Vous pouvez redemander le code dans ${timeBeforeRessent.value} s",
//                 align: TextAlign.center,
//                 size: 20,
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }

//   count() {
//     timer = Timer.periodic(1.seconds, (timer) {
//       timeBeforeRessent--;
//       timeBeforeRessent.value == 0 ? timer.cancel() : null;
//     });
//   }
// }
