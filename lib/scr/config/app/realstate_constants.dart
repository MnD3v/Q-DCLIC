import 'package:immobilier_apk/scr/config/app/export.dart';

abstract class Regions {
  static String savanes = 'Savanes';
  static String kara = 'Kara';
  static String centrale = 'Centrale';
  static String plateaux = 'Plateaux';
  static String maritime = 'Maritime';
}

abstract class Constants {
  static String savanes = 'Savanes';
  static String kara = 'Kara';
  static String centrale = 'Centrale';
  static String plateaux = 'Plateaux';
  static String maritime = 'Maritime';
    static List<String> roles = [
    "Agence immoblière",
    "Agent commercial",
    "Avocat immobilier",
    "Constructeur",
    "Huissier",
    "Notaire",
    
  ];

  
  static Map<String, Map<String, List<String>>> localites = {
    savanes: {
      "Cinkasse": ["quartier1"],
      "Dapaong": ["quartier1"],
      "Gando": ["quartier1"],
      "Mandouri": ["quartier1"],
      "Mango": ["quartier1"],
      "Naki-Est": ["quartier1"],
      "Tandjouare": ["quartier1"],
    },
    kara: {
      "Bafilo": ["quartier1"],
      "Bassar": ["quartier1"],
      "Gerin-kouka": ["quartier1"],
      "Kante": ["quartier1"],
      "Kara": ["quartier1"],
      "Niamtougou": ["quartier1"],
      "Pagouda": ["quartier1"],
    },
    centrale: {
      "Blitta": ["quartier1"],
      "Djarkpanga": ["quartier1"],
      "Sotouboua": ["quartier1"],
      "Sokode": ["quartier1"],
      "Tchamba": ["quartier1"],
    },
    plateaux: {
      "Adeta": ["quartier1"],
      "Agou-Gadzepe": ["quartier1"],
      "Amlame": ["quartier1"],
      "Anie": ["quartier1"],
      "Atakpame": ["quartier1"],
      "Badou": ["quartier1"],
      "Danyi-Apeyeme ": ["quartier1"],
      "Elavagnon": ["quartier1"],
      "Kougnohou": ["quartier1"],
      "Kpalime": ["quartier1"],
      "Notsè": ["quartier1"],
      "Tohoun": ["quartier1"],
    },
    maritime: {
      "Agoè-Nyive": ["quartier1"],
      "Aneho": ["quartier1"],
      "Afagnan": ["quartier1"],
      "Keve": ["quartier1"],
      "Lome": ["Agoe", "Agbalepedo"],
      "Tabligbo": ["quartier1"],
      "Tsevie": ["quartier1"],
      "Vogan": ["quartier1"],
    }
  };
  static List<String> categories = [
    Categories.chambres,
    Categories.terrains,
    Categories.maisons,
    Categories.boutiques,
    Categories.bureau,
  ];
}
