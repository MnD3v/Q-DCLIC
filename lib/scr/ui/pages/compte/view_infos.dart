import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class ViewInfos extends StatelessWidget {
  const ViewInfos({super.key});

  @override
  Widget build(BuildContext context) {
    var utilisateur = Utilisateur.currentUser.value!;
    return EScaffold(
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
        EText(utilisateur.telephone.indicatif + " " + utilisateur.telephone.numero),
        12.h,
        EText("Entreprises", size: 22, weight: FontWeight.bold,),
        9.h,
        Wrap(children: utilisateur.entreprises.map((element){
          return Container( padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12), margin: EdgeInsets.only(right: 9), decoration: BoxDecoration(color: AppColors.color500, borderRadius: BorderRadius.circular(6)), child: EText(element.nom, color: Colors.white,),);
        }).toList(),)
      ]),
    ));
  }
}