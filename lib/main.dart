// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:immobilier_apk/firebase_options.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/theme/app_theme.dart';
import 'package:immobilier_apk/scr/ui/pages/precache/precache.dart';
import 'package:immobilier_apk/scr/ui/pages/update/update_page.dart';

String version = "1.0.1+14";

Update update = Update(version: "1.0.1+14", optionel: false);

double phoneScallerFactor = 1;

DateTime? currentDate;

Map<int, Map<String, String>> id_datas = {};

int? currentId;


var firestoreDb = FirebaseFirestore.instance;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 


  var user = FirebaseAuth.instance.currentUser;
  if (user.isNotNul) {
    if (user!.email != null) {
      await Utilisateur.getUser(user.email!);
    } else {
      await Utilisateur.getUser(user.phoneNumber!.substring(4));
    }
    // verifyPaiements();
  }
  // await requestNotificationPermission();

  runApp(GetMaterialApp(
    defaultTransition: Transition.rightToLeftWithFade,
    transitionDuration: 444.milliseconds,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: LoadingPage(),
  
  ));

}

void goToDetailPage({required Map<String, dynamic> notificationData}) async {
  var update = await getUpdateVersion();
  if (update.version != version) {
    Get.off(
      const UpdatePage(),
      transition: Transition.rightToLeftWithFade,
      duration: 333.milliseconds,
    );
  } else {
    
   

  
    
  }
}



Future<String?> getPaygateApiKey() async {
  DocumentSnapshot<Map<String, dynamic>> q;
  try {
    q = await DB.firestore(Collections.keys).doc('apiKey').get();
    return q != null ? q.data()!['apiKey'] : null;
  } on Exception {
    // TODO
  }
  return null;
}

Future<Update> getUpdateVersion() async {
  var q = await DB.firestore(Collections.keys).doc('update').get();
  return Update.fromMap(q.data() ?? update.toMap());
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Demander la permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('Permission refusée par l\'utilisateur.');
  } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
    print('Permission non encore déterminée.');
  } else {
    print('Permission accordée : ${settings.authorizationStatus}');
  }
}