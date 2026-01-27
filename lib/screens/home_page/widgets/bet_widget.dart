import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:esme2526/domain/user_bet_case.dart';

class BetWidget extends StatelessWidget {
  final Bet bet;

  const BetWidget({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 8.0,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Fond d'image
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // NOUVEAU : On force une image specifique
                  image: NetworkImage('https://images.pexels.com/photos/270085/pexels-photo-270085.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Overlay sombre pour la lisibilité
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Contenu texte et bouton
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      bet.title,
                      style: GoogleFonts.bebasNeue(fontSize: 28, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: Colors.black)]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final userBet = UserBet(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: '1',
                        betId: bet.id,
                        amount: 0,
                        odds: bet.odds,
                        payout: 0,
                        createdAt: DateTime.now(),
                      );
                      await UserBetCase().createUserBet(userBet);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pari ajouté à votre sélection !'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Cote : ${bet.odds.toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
