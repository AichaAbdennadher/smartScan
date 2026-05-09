import 'dart:io';
import 'package:flutter/material.dart';
import '../services/ml_kit_service.dart';
import '../services/audio_vibration_service.dart';

class ScanProvider extends ChangeNotifier {

//intialisation 
  final MLKitService _mlKitService = MLKitService();
  final AudioVibrationService _audioVibrationService = AudioVibrationService();


  File? _image;
  String _recognizedText = ''; //texte reconnu
  String _detectedLanguage = '';
  String _translatedText = '';
  String _targetLanguage = '';//langue cible
  bool _isProcessing = false;//traitement en cours

  static const List<Map<String, String>> supportedLanguages = [
    {'name': 'Français', 'code': 'fr'},
    {'name': 'English', 'code': 'en'},
    {'name': 'Arabe', 'code': 'ar'},
    {'name': 'Español', 'code': 'es'},
    {'name': 'Deutsch', 'code': 'de'},
    {'name': 'Italiano', 'code': 'it'},
    {'name': 'Português', 'code': 'pt'},
    {'name': 'Русский', 'code': 'ru'},
    {'name': '日本語', 'code': 'ja'},
    {'name': '中文', 'code': 'zh'},
    {'name': '한국어', 'code': 'ko'},
    {'name': 'हिन्दी', 'code': 'hi'},
  ];

//getters
  File? get image => _image;
  String get recognizedText => _recognizedText;
  String get detectedLanguage => _detectedLanguage;
  String get translatedText => _translatedText;
  String get targetLanguage => _targetLanguage;
  bool get isProcessing => _isProcessing;

//setters
  void setImage(File image) {
    _image = image;
    _recognizedText = '';
    _detectedLanguage = '';
    _translatedText = '';
    _targetLanguage = '';
    notifyListeners(); ////Pour dire à Flutter : “les données ont changé → met à jour l’interface (UI)”
  }

 //{ } en Dart indiquent des paramètres nommés Ça veut dire que tu dois préciser le nom du paramètre quand tu appelles la fonction :
  Future<void> processImage({
    String? targetLanguage,
    bool isSoundEnabled = true,
    bool isVibrationEnabled = true,
  }) async {
    if (_image == null) return;
    //On réinitialise les anciens résultats.
    _isProcessing = true;
    _recognizedText = '';
    _detectedLanguage = '';
    _translatedText = '';
    notifyListeners();

    try {
      // 1. OCR (reconnaissance de texte)
      _recognizedText = await _mlKitService.recognizeText(_image!.path);
      
      // 2. Language ID
      _detectedLanguage = await _mlKitService.identifyLanguage(_recognizedText);
      
      // 3. Feedback
      if (isVibrationEnabled) await _audioVibrationService.vibrate();
      if (isSoundEnabled) await _audioVibrationService.playSuccessSound();

      // 4. Auto-translation if target is provided
      if (targetLanguage != null && _recognizedText.isNotEmpty) {
        await translate(targetLanguage, isSoundEnabled: isSoundEnabled);
      }
    } catch (e) {
      _recognizedText = 'Erreur lors du traitement: $e';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> translate(String targetLanguage, {bool isSoundEnabled = true}) async {
    if (_recognizedText.isEmpty) return;

    _isProcessing = true;
    _translatedText = ''; // Clear previous translation while processing
    _targetLanguage = targetLanguage;
    notifyListeners();

    try {
      _translatedText = await _mlKitService.translateText(
        text: _recognizedText,
        sourceLanguage: _detectedLanguage,
        targetLanguage: targetLanguage,
      );
      if (isSoundEnabled) await _audioVibrationService.playSuccessSound();
    } catch (e) {
      _translatedText = 'Erreur lors de la traduction: $e';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clear() {
    _image = null;
    _recognizedText = '';
    _detectedLanguage = '';
    _translatedText = '';
    _targetLanguage = '';
    notifyListeners();
  }
}


//Partager les données (_recognizedText, _translatedText, _image, etc.) avec plusieurs écrans