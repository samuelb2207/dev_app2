import 'package:esme2526/domain/user_use_case.dart';
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
    _userFuture = UserUseCase().getUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Erreur de chargement de l'utilisateur: ${snapshot.error}")));
        }

        final user = snapshot.data!;
        final List<Widget> widgetOptionsWithUser = <Widget>[
          const HomePage(),
          const UserBetsPage(),
          ProfileWidget(user: user),
        ];

        return Scaffold(
          // NOUVEAU : On supprime l'AppBar pour ne pas avoir de titre en double
          appBar: null,
          body: Center(
            child: widgetOptionsWithUser.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Accueil'),
              BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), activeIcon: Icon(Icons.sports_esports), label: 'Mes Paris'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            backgroundColor: Theme.of(context).cardColor,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}
