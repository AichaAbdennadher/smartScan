import 'package:flutter/material.dart';
import '../types.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'results_screen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  ScreenType _currentScreen = ScreenType.home;

  Widget _buildPage(ScreenType screen) {
    switch (screen) {
      case ScreenType.home:
        return HomeScreen(onNavigate: _onNavigate);
      case ScreenType.scan:
        return ScannerScreen(onNavigate: _onNavigate);
      case ScreenType.history:
        return const HistoryScreen();
      case ScreenType.settings:
        return SettingsScreen(onNavigate: _onNavigate);
      case ScreenType.about:
        return AboutScreen(onNavigate: _onNavigate);
      case ScreenType.results:
        return ResultsScreen(onNavigate: _onNavigate); 
    }
  }

  void _onNavigate(ScreenType screen) {
    if (screen == _currentScreen) return;
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Current index for IndexedStack based on ScreenType
    final List<ScreenType> tabOrder = [
      ScreenType.home,
      ScreenType.scan,
      ScreenType.history,
      ScreenType.settings,
      ScreenType.about,
      ScreenType.results,
    ];
    
    int currentIndex = tabOrder.indexOf(_currentScreen);
    if (currentIndex == -1) currentIndex = 0; // Default to home

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: tabOrder.map((type) => _buildPage(type)).toList(),
      ),
      bottomNavigationBar: BottomNav(
        currentScreen: _currentScreen,
        onNavigate: _onNavigate,
      ),
    );
  }
}

// L'objectif de la page 

// NavigationShell
//  est de servir de "coque" ou de conteneur principal pour toute l'interface de ton application. Voici ses rôles précis :

// Gestion de la Navigation Centrale : C'est elle qui fait le pont entre la barre de navigation du bas (BottomNav) et l'affichage des différents écrans (Accueil, Scan, Histoire, Paramètres).
// Persistance de l'État (IndexedStack) : Elle utilise un widget appelé IndexedStack. Cela permet de garder tous les écrans "en vie" en mémoire.
// Exemple : Si tu es en plein milieu d'un scan et que tu vas dans les Paramètres pour changer la langue, quand tu reviens sur l'onglet Scan, tu retrouves exactement où tu en étais (la caméra est toujours prête, les données ne sont pas perdues).
// Structure Scaffold commune : Elle définit le Scaffold principal qui contient le body (les pages) et le bottomNavigationBar. Cela garantit que la barre de navigation reste fixe et cohérente pendant que tu navigues.
// Callback de Navigation : Elle fournit la fonction 

// _onNavigate
//  à tous les sous-écrans. Cela permet par exemple à un bouton sur la page d'Accueil de commander au Shell de changer d'onglet pour aller vers le Scan.
// En résumé, c'est le chef d'orchestre qui décide quelle page afficher tout en s'assurant que l'utilisateur ne perd pas sa progression en changeant d'onglet.