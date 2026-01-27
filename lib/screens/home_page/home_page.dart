import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/screens/home_page/widgets/bet_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447), // On remet un fond de couleur unie
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Paris Disponibles',
                style: GoogleFonts.bebasNeue(fontSize: 36, color: Colors.white),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Bet>>(
                stream: BetRepositoryHive().getBetsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final bets = snapshot.data!;
                    return ListView.builder(
                      itemCount: bets.length,
                      itemBuilder: (context, index) {
                        return BetWidget(bet: bets[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('Aucun pari disponible.', style: TextStyle(color: Colors.white)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
