import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewInfos extends StatelessWidget {
  const ViewInfos({super.key});

  @override
  Widget build(BuildContext context) {
    var utilisateur = Utilisateur.currentUser.value!;
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 700.0 ? 700.0 : constraints.maxWidth;

      return EScaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: EScaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  title: EText(
                    "Informations",
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: EColumn(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: SizedBox(
                              height: min(Get.width * .6, 500),
                              child: QrImageView(
                                data: utilisateur.telephone_id,
                                backgroundColor: Colors.transparent,
                                eyeStyle: QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: AppColors.color500),
                                dataModuleStyle: QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(6),
                              )),
                        ),
                                         
                        EText(utilisateur.nom + " " + utilisateur.prenom),
                        EText(utilisateur.telephone_id),
                      ]),
                    ),
                  ),
                )),
          ),
        ),
      );
    });
  }
}
