import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyHistory = 'scan_history';
  static const String _keySettings = 'app_settings';

  //cette fonction permet de sauvegarder un scan dans _history
  Future<void> saveScan(Map<String, dynamic> scanData) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyHistory) ?? [];
    // jsonEncode() convertit un objet Dart (comme Map) en chaîne JSON (String) car sharedprefernces ne stoke que les types primtifs 
    history.add(jsonEncode(scanData));
    await prefs.setStringList(_keyHistory, history);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyHistory) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, jsonEncode(settings));
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsStr = prefs.getString(_keySettings);
    if (settingsStr == null) return null;
    return jsonDecode(settingsStr) as Map<String, dynamic>;
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }

  Future<void> deleteScans(List<int> indices) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_keyHistory) ?? [];
    
    // Tri des indices en ordre décroissant
    //    → Si on supprimait d’abord les indices les plus petits,
    //      chaque suppression ferait “glisser” les éléments vers la gauche
    //      et les indices suivants deviendraient décalés → erreurs de hors‑bornes.    
    final sortedIndices = List<int>.from(indices)..sort((a, b) => b.compareTo(a));
    
    for (final index in sortedIndices) {
      if (index >= 0 && index < history.length) {
        history.removeAt(index);
      }
    }
    
    await prefs.setStringList(_keyHistory, history);
  }
}
