import 'package:esme2526/datas/user_bet_repository_interface.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:hive_ce/hive.dart';

class UserBetRepositoryHive implements UserBetRepositoryInterface {
  final Future<Box<UserBet>> _userBetsBoxFuture;

  static UserBetRepositoryHive? _instance;

  UserBetRepositoryHive._internal() : _userBetsBoxFuture = Hive.openBox<UserBet>('userBets');

  factory UserBetRepositoryHive() {
    _instance ??= UserBetRepositoryHive._internal();
    return _instance!;
  }

  @override
  Future<List<UserBet>> getUserBets() async {
    final box = await _userBetsBoxFuture;
    return box.values.toList();
  }

  @override
  Stream<List<UserBet>> getUserBetsStream() async* {
    final box = await _userBetsBoxFuture;
    yield box.values.toList();

    yield* box.watch().map((event) => box.values.toList());
  }

  @override
  Future<void> saveUserBet(UserBet userBet) async {
    final box = await _userBetsBoxFuture;
    // On utilise l'ID du pari comme clé pour une suppression facile
    await box.put(userBet.id, userBet);
  }

  // NOUVEAU : Fonction pour supprimer un pari utilisateur
  Future<void> deleteUserBet(String userBetId) async {
    final box = await _userBetsBoxFuture;
    await box.delete(userBetId);
  }
}
