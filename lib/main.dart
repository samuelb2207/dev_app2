import 'package:esme2526/screens/user_page.dart';
import 'package:esme2526/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:esme2526/hive/hive_registrar.g.dart'; // Assurez-vous que ce chemin est correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // NOUVEAU : Suppression de la bannière de débogage
      debugShowCheckedModeBanner: false,
      title: 'ESME Bet',
      theme: ThemeData.dark().copyWith(
        // NOUVEAU : Fond d'application complètement noir
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Appbar noire également
          elevation: 0, // Aucune ombre
        ),
        cardColor: const Color(0xFF1A1A2E), // Maintient la couleur des cartes
      ),
      home: UserPage(),
    );
  }
}
