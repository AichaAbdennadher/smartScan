import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import '../providers/scan_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';
import '../services/tts_service.dart';
import '../types.dart';

class ResultsScreen extends StatefulWidget {
  final ValueChanged<ScreenType> onNavigate;
  const ResultsScreen({super.key, required this.onNavigate});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TTSService _ttsService = TTSService();
  bool _isPlayingOriginal = false;
  bool _isPlayingTranslation = false;

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  void _togglePlayback(String text, String lang, bool isOriginal) async {
    if (isOriginal ? _isPlayingOriginal : _isPlayingTranslation) {
      await _ttsService.stop();
      setState(() {
        if (isOriginal) _isPlayingOriginal = false;
        else _isPlayingTranslation = false;
      });
    } else {
      await _ttsService.stop(); // Stop any current
      setState(() {
        _isPlayingOriginal = isOriginal;
        _isPlayingTranslation = !isOriginal;
      });
      await _ttsService.speak(text, lang);
      if (mounted) {
        setState(() {
          _isPlayingOriginal = false;
          _isPlayingTranslation = false;
        });
      }
    }
  }

  Future<void> _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copié'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanProvider = context.watch<ScanProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (scanProvider.image == null && !scanProvider.isProcessing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.noHistory), // Reuse no history for now or add l10n
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => widget.onNavigate(ScreenType.home),
                child: Text(l10n.backHome),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerHighest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            scanProvider.clear();
            widget.onNavigate(ScreenType.scan);
          },
        ),
        title: Text(
          l10n.resultsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              // ── Image Preview ──
              if (scanProvider.image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: kIsWeb 
                      ? Image.network(scanProvider.image!.path, height: 200, width: double.infinity, fit: BoxFit.cover)
                      : Image.file(scanProvider.image!, height: 200, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),

              // ── Original Text Card ──
              _TextCard(
                heading: l10n.recognizedText,
                headingColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                headerSuffix: _buildDetectedBadge(scanProvider.detectedLanguage, l10n),
                text: scanProvider.recognizedText,
                textStyle: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
                borderColor: colorScheme.outlineVariant,
                borderWidth: 1,
                isPlaying: _isPlayingOriginal,
                onCopy: () => _copyToClipboard(scanProvider.recognizedText, l10n.recognizedText),
                onPlay: () => _togglePlayback(scanProvider.recognizedText, scanProvider.detectedLanguage, true),
              ),

              const SizedBox(height: 24),

              // ── Target Language Selection ──
              _TranslationSelector(scanProvider: scanProvider, l10n: l10n, isDark: isDark),

              const SizedBox(height: 24),

              // ── Translation Card ──
              _TextCard(
                heading: l10n.translation,
                headingColor: const Color(0xFF3B82F6),
                text: scanProvider.isProcessing ? '...' : (scanProvider.translatedText.isNotEmpty ? scanProvider.translatedText : l10n.scannerAnalysis),
                textStyle: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                borderColor: const Color(0xFF3B82F6).withOpacity(0.3),
                borderWidth: 2,
                isPlaying: _isPlayingTranslation,
                onCopy: () => _copyToClipboard(scanProvider.translatedText, l10n.translation),
                onPlay: () => _togglePlayback(scanProvider.translatedText, scanProvider.targetLanguage, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedBadge(String code, AppLocalizations l10n) {
    if (code.isEmpty || code == 'und') return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getFlag(code), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '${_getLanguageName(code)} ${l10n.detected}',
            style: const TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'fr': return 'Français';
      case 'en': return 'Anglais';
      case 'ar': return 'Arabe';
      case 'es': return 'Espagnol';
      case 'de': return 'Allemand';
      case 'it': return 'Italien';
      case 'pt': return 'Portugais';
      case 'ru': return 'Russe';
      case 'ja': return 'Japonais';
      case 'zh': return 'Chinois';
      case 'ko': return 'Coréen';
      case 'hi': return 'Hindi';
      default: return code;
    }
  }

  String _getFlag(String code) {
    switch (code) {
      case 'fr': return '🇫🇷';
      case 'en': return '🇺🇸';
      case 'ar': return '🇸🇦'; 
      case 'es': return '🇪🇸';
      case 'de': return '🇩🇪';
      case 'it': return '🇮🇹';
      case 'pt': return '🇵🇹';
      case 'ru': return '🇷🇺';
      case 'ja': return '🇯🇵';
      case 'zh': return '🇨🇳';
      case 'ko': return '🇰🇷';
      case 'hi': return '🇮🇳';
      default: return '';
    }
  }
}

class _TextCard extends StatelessWidget {
  final String heading;
  final Color headingColor;
  final String text;
  final TextStyle textStyle;
  final Color borderColor;
  final double borderWidth;
  final bool isPlaying;
  final Widget? headerSuffix;
  final VoidCallback onCopy;
  final VoidCallback onPlay;

  const _TextCard({
    required this.heading, 
    required this.headingColor, 
    required this.text, 
    required this.textStyle, 
    required this.borderColor, 
    required this.borderWidth, 
    this.isPlaying = false,
    this.headerSuffix,
    required this.onCopy,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(heading.toUpperCase(), style: TextStyle(color: headingColor, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2)),
              const Spacer(),
              if (headerSuffix != null) headerSuffix!,
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(text, style: textStyle),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.copy_outlined, size: 20), 
                tooltip: l10n.copy,
                color: headingColor.withOpacity(0.7), 
                visualDensity: VisualDensity.compact, 
                onPressed: onCopy
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onPlay,
                child: Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TranslationSelector extends StatelessWidget {
  final ScanProvider scanProvider;
  final AppLocalizations l10n;
  final bool isDark;
  const _TranslationSelector({required this.scanProvider, required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.translateTo.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: scanProvider.targetLanguage.isEmpty ? null : scanProvider.targetLanguage,
              hint: Text('Choisir une langue...', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 14)),
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              onChanged: (String? newLanguage) {
                if (newLanguage != null) {
                  final settings = context.read<SettingsProvider>();
                  scanProvider.translate(newLanguage, isSoundEnabled: settings.isSoundEnabled);
                }
              },
              items: ScanProvider.supportedLanguages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['code'],
                  child: Text(lang['name']!, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}


