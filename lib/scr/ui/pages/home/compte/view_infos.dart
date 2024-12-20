import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class ViewInfos extends StatelessWidget {
  const ViewInfos({super.key});

  @override
  Widget build(BuildContext context) {
    var utilisateur = Utilisateur.currentUser.value!;
    return  LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth > 700.0 ? 700.0 : constraints.maxWidth;

        return 
        EScaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: EScaffold(
                appBar: AppBar(
                 backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  title: 
                  EText("Informations", size: 24, weight: FontWeight.bold,),
                ),
                body: 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EColumn(children: [
                  EText("Informations personnelles", size: 22, weight: FontWeight.bold,),
              
                  EText(utilisateur.nom + " " + utilisateur.prenom) ,
                  EText( utilisateur.telephone_id),
              
               
                ]),
              )),
            ),
          ),
        );
      }
    );
  }
}