import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {

  final StorageService _storageService = StorageService();
  //map(dict ;cle : value) exmple :
  // {
  // "text": "Bonjour",
  // "date": "2026-03-20",
  // "language": "fr"
  // }
  List<Map<String, dynamic>> _history = []; //contient tous les scans effectués
  List<Map<String, dynamic>> get history => _history;

  HistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _history = await _storageService.getHistory();
    notifyListeners(); //Pour dire à Flutter : “les données ont changé → pour mettre à jour l'écran d'historique dès qu'un nouveau scan est ajouté.
  }

  Future<void> addScan(Map<String, dynamic> scan) async { //ajoute un nouveau scan dans _history
    await _storageService.saveScan(scan);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    await loadHistory();
  }

  Future<void> deleteScans(List<int> indices) async {
    await _storageService.deleteScans(indices);
    await loadHistory();
  }
}



