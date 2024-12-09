
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home/home_page.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                child: Image(
                    image: AssetImage(Assets.image('update.png')),
                    fit: BoxFit.contain)),
            24.h,
            EText(
              "Une mise à jour est disponible !",
              size: 25,
              color: AppColors.color500,
              weight: FontWeight.w900,
            ),
            12.h,
            const EText(
              "Votre application est actuellement obsolète. Veuillez télécharger la dernière mise à jour disponible.",
              // size: 22,
              align: TextAlign.center,
              maxLines: 12,
            ),
            6.h,
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: "Taille de télechargement: "),
                TextSpan(
                    text: "5,7 Mo ",
                    style: TextStyle(
                        color: AppColors.color500, fontWeight: FontWeight.bold))
              ]),
              textScaleFactor: .7,
            ),
            12.h,
            SimpleButton(
              height: 45,
              width: Get.width / 2,
              onTap: () async {
            
              },
              text: 'Telecharger',
            ),
            6.h,
            update.optionel == true
                ? SimpleButton(
                    height: 46,
                    color: Colors.black26,
                    width: Get.width / 2,
                    onTap: () async {
                      var user = FirebaseAuth.instance.currentUser;

                      Get.off(HomePage(),
                          transition: Transition.rightToLeftWithFade,
                          duration: 333.milliseconds,
                        );
                    },
                    child: EText('Plus tard',
                        weight: FontWeight.normal, color: AppColors.color500),
                  )
                : 0.h
          ],
        ),
      ),
    );
  }
}
