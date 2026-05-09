import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class MLKitService {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final LanguageIdentifier _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);

  /// Extract text from an image path
  Future<String> recognizeText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    //_textRecognizer contient tous les methodes de OCR 
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  /// Identify the language of the provided text
  Future<String> identifyLanguage(String text) async {
    if (text.isEmpty) return 'und';
    final String languageCode = await _languageIdentifier.identifyLanguage(text);
    return languageCode;
  }

  /// Translate text from source to target language
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (text.isEmpty) return '';
    
    final bcpSource = _getBCP47(sourceLanguage);// il nécessite un TranslateLanguage (une enum du SDK)
    final bcpTarget = _getBCP47(targetLanguage);

    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: bcpSource,
      targetLanguage: bcpTarget,
    );

    try {
      final String response = await onDeviceTranslator.translateText(text);
      return response;
    } finally {
      onDeviceTranslator.close();
    }
  }

  /// Helper to map language codes to TranslateLanguage enum
  TranslateLanguage _getBCP47(String code) {
    switch (code) {
      case 'en': return TranslateLanguage.english;
      case 'fr': return TranslateLanguage.french;
      case 'ar': return TranslateLanguage.arabic;
      case 'es': return TranslateLanguage.spanish;
      case 'de': return TranslateLanguage.german;
      case 'it': return TranslateLanguage.italian;
      case 'pt': return TranslateLanguage.portuguese;
      case 'ru': return TranslateLanguage.russian;
      case 'ja': return TranslateLanguage.japanese;
      case 'zh': return TranslateLanguage.chinese;
      case 'ko': return TranslateLanguage.korean;
      case 'hi': return TranslateLanguage.hindi;
      default: return TranslateLanguage.english;
    }
  }

  void dispose() { //liberation
    _textRecognizer.close();
    _languageIdentifier.close();
  }
}
