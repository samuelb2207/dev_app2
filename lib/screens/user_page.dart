import 'dart:math';

import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/domain/bet_use_case.dart';
import 'package:esme2526/domain/user_use_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user.dart';
import 'package:esme2526/screens/home_page/home_page.dart';
import 'package:esme2526/screens/profile_widget.dart';
import 'package:esme2526/screens/user_bets_page.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    UserUseCase userUseCase = UserUseCase();
    _userFuture = userUseCase.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...'), backgroundColor: Colors.white),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.white),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(user.name), backgroundColor: Colors.white),
          body: _getBody(_selectedIndex, user),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              List<Bet> bets = await BetUseCase().getBets();
              Bet randomBet = bets[Random().nextInt(bets.length)];

              BetRepositoryHive().saveBets([randomBet]);
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(.60),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            currentIndex: _selectedIndex,
            onTap: (value) {
              print("Test BottomNavigationBar: $value");
              setState(() {
                _selectedIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
              BottomNavigationBarItem(label: 'Bets', icon: Icon(Icons.sports_esports)),
              BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        );
      },
    );
  }

  Widget _getBody(int index, User user) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return UserBetsPage();
      case 2:
        return ProfileWidget(user: user);
      default:
        return const Center(child: Text('Home'));
    }
  }
}
