import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _isDarkMode = false;//stocke l'etat actuelle du dark mode 
  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;
  String _language = 'en'; 
  bool _hasSeenOnboarding = false;

  bool get isDarkMode => _isDarkMode;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  String get language => _language;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light; //transforme le booléen en type ThemeMode.dark ou ThemeMode.light.

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storageService.getSettings();
    if (settings != null) {
      _isDarkMode = settings['isDarkMode'] ?? false;
      _isSoundEnabled = settings['isSoundEnabled'] ?? true;
      _isVibrationEnabled = settings['isVibrationEnabled'] ?? true;
      _language = settings['language'] ?? 'en';
      // _hasSeenOnboarding = settings['hasSeenOnboarding'] ?? false; // Chargement depuis la mémoire
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode(bool value) async { //permet de changer le dark mode 
    _isDarkMode = value;
    await _saveSettings();
    notifyListeners(); //appel a chaque changement avertit toute l'application que le thème a changé pour qu'elle se redessine instantanément.
 //elle dit à Flutter : "Hé, les données ont changé ! Re-dessine tous les widgets qui utilisent cette info"
  }

  Future<void> toggleSound(bool value) async {
    _isSoundEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> toggleVibration(bool value) async {
    _isVibrationEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _saveSettings();
    notifyListeners();
  }

//lorsque l'utilisateur (clique sur commencer)termine l'onboarding on stocke _hasSeenOnboarding = true 
//comme ca la prochaine fois on affiche pas l'onboarding 
  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    // await _saveSettings(); // Sauvegarde permanente mise en commentaire pour montrer le principe
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _storageService.saveSettings({
      'isDarkMode': _isDarkMode,
      'isSoundEnabled': _isSoundEnabled,
      'isVibrationEnabled': _isVibrationEnabled,
      'language': _language,
      // 'hasSeenOnboarding': _hasSeenOnboarding, // Ligne de sauvegarde mise en commentaire
    });
  }
}
