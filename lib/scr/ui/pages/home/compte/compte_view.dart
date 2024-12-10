import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/compte/view_infos.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:url_launcher/url_launcher.dart';


class Compte extends StatelessWidget {
  const Compte({super.key});

  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<OtherController>();
    return EScaffold(
      color: Colors.transparent,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const BigTitleText(
          "Mon compte",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: EColumn(children: [
          12.h,
          GestureDetector(
            onTap: () {
              if (Utilisateur.currentUser.value == null) {
                Get.to(
                    Connexion(
                   
                    ),
                    fullscreenDialog: true);
              } else {
                
                Get.to(ViewInfos());
              }
            },
            child: Container(
              height: 70,
              width: Get.width,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage(Assets.icons("account_2.png")),
                        color: Colors.amber,
                      ),
                      9.w,
                      Obx(
                        () => Utilisateur.currentUser.value != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  EText(
                                    "${Utilisateur.currentUser.value!.nom} ${Utilisateur.currentUser.value!.prenom}",
                                    weight: FontWeight.bold,
                                    size: 22,
                                  ),
                                  EText(
                                      Utilisateur.currentUser.value!.telephone_id)
                                ],
                              )
                            : const EText(
                                "Me connecter / M'inscrire",
                                weight: FontWeight.bold,
                              ),
                      )
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.white54,
                  )
                ],
              ),
            ),
          ),
          12.h,
        
          
          const BigTitleText(
            "Plus",
          ),
          9.h,
          _Element(
            onTap: () {
              launchUrl(Uri.parse(
                  "https://sites.google.com/view/moger-conditions/accueil"));
            },
            title: "Conditions générales d'utilisation",
          ),
          9.h,
          _Element(
            onTap: () {
              launchUrl(Uri.parse(
                  "https://sites.google.com/view/moger-protection/accueil"));
            },
            title: "Protection de données",
          ),
          9.h,
         
          24.h,
          Obx(
            () => Utilisateur.currentUser.value == null
                ? 0.h
                : Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Custom.showDialog( dialog: TwoOptionsDialog(
                              confirmationText: "Me deconnecter",
                              confirmFunction: () {
                                FirebaseAuth.instance.signOut();
                                Utilisateur.currentUser.value = null;
                               
                              //  Get.off(Connexion());
                               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Connexion(),), (route) => false,);
                                Toasts.success(context,
                                    description:
                                        "Vous vous êtes déconnecté avec succès");
                              },
                              body: "Voulez-vous vraiment vous deconnecter ?",
                              title: "Déconnexion"));
                        },
                        child: Container(
                          height: 55,
                          width: Get.width,
                          padding: const EdgeInsets.all(9),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.color500),
                              borderRadius: BorderRadius.circular(12)),
                          child: EText(
                            "Deconnexion",
                            weight: FontWeight.w600,
                            color: AppColors.color500,
                            size: 22,
                          ),
                        ),
                      ),
                      24.h,
                    ],
                  ),
          ),
          Center(
              child: Image(image: AssetImage(Assets.image("logo.png")), height: 45,)),
          const Center(
            child: EText("v1.0.0"),
          ),
          90.h,
        ]),
      ),
    );
  }
}

class _Element extends StatelessWidget {
  const _Element({
    required this.onTap,
    required this.title,
  });
  final onTap;
  final title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: Get.width,
        padding: const EdgeInsets.all(9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                EText(
                  title,
                  weight: FontWeight.w600,
                  size: 21,
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.white54,
            )
          ],
        ),
      ),
    );
  }
}
