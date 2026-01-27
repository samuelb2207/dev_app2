import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/datas/user_bet_repository_hive.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:esme2526/screens/bet_page.dart';
import 'package:flutter/material.dart';

class UserBetsPage extends StatelessWidget {
  const UserBetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBetRepository = UserBetRepositoryHive();
    final betRepository = BetRepositoryHive();

    return FutureBuilder<List<Bet>>(
      future: betRepository.getBets(),
      builder: (context, betsSnapshot) {
        if (!betsSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final allBets = {for (var bet in betsSnapshot.data!) bet.id: bet};

        return StreamBuilder<List<UserBet>>(
          stream: userBetRepository.getUserBetsStream(),
          builder: (context, userBetsSnapshot) {
            if (userBetsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userBetsSnapshot.hasError) {
              return Center(child: Text('Erreur: ${userBetsSnapshot.error}'));
            }

            final userBets = userBetsSnapshot.data ?? [];

            if (userBets.isEmpty) {
              return const Center(
                child: Text('Aucun pari dans votre sélection', style: TextStyle(fontSize: 18, color: Colors.grey)),
              );
            }

            return ListView.builder(
              itemCount: userBets.length,
              itemBuilder: (context, index) {
                final userBet = userBets[index];
                final betDetails = allBets[userBet.betId];

                if (betDetails == null) {
                  return const SizedBox.shrink();
                }

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(betDetails.title, style: Theme.of(context).textTheme.titleLarge)),
                            // NOUVEAU : Bouton de suppression
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                await userBetRepository.deleteUserBet(userBet.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Pari supprimé de la sélection.'), backgroundColor: Colors.red),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          betDetails.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // MODIFIÉ : On formate la cote pour avoir toujours 2 décimales
                            Text('Cote : ${betDetails.odds.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BetPage(bet: betDetails)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Valider ce Pari'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
