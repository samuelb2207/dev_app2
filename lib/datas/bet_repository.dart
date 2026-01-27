import 'dart:async';

import 'package:esme2526/datas/bet_repository_interface.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/data_bet.dart';

class BetRepository implements BetRepositoryInterface {
  StreamController<List<Bet>> betsStreamController = StreamController<List<Bet>>();

  @override
  Future<void> saveBets(List<Bet> bets) async {
    betsStreamController.add(bets);
  }

  @override
  Stream<List<Bet>> getBetsStream() async* {
    List<Bet> bets = await getBets();
    yield bets;
  }

  @override
  Future<List<Bet>> getBets() async {
    // On utilise une image placeholder pour tous les paris
    const String placeholderImg = "https://images.pexels.com/photos/270085/pexels-photo-270085.jpeg";
    return [
      Bet(
        id: "1",
        title: "Match de Football - Coupe du Monde",
        description: "Parier sur le vainqueur du match France vs Brésil",
        odds: 2,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        dataBet: DataBet(id: "1", imgUrl: placeholderImg),
      ),
      Bet(
        id: "2",
        title: "Tennis - Finale Roland Garros",
        description: "Qui remportera le titre cette année?",
        odds: 3,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 3)),
        dataBet: DataBet(id: "2", imgUrl: placeholderImg),
      ),
       Bet(
        id: "3",
        title: "Basket - NBA Finals",
        description: "Prédire le score final de la série",
        odds: 4,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 4)),
        dataBet: DataBet(id: "3", imgUrl: placeholderImg),
      ),
      Bet(
        id: "4",
        title: "Formule 1 - Grand Prix de Monaco",
        description: "Quel pilote obtiendra la pole position?",
        odds: 5,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        dataBet: DataBet(id: "4", imgUrl: placeholderImg),
      ),
    ];
  }
}
