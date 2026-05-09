import 'package:flutter_tts/flutter_tts.dart';

class TTSService { //service de text to speech
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text, String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
