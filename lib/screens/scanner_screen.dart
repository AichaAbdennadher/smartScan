import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import '../providers/scan_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';
import '../types.dart';

class ScannerScreen extends StatefulWidget {
  final ValueChanged<ScreenType> onNavigate;

  const ScannerScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  bool _isScanning = false;

  late final AnimationController _scanLineCtrl;
  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

// cette fonction permet de prendre une image depuis la galerie ou l'appareil photo
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source); //capturer l image partir de source(camera ou galerie)
    
    if (pickedFile != null) { //si l image est capturée
      if (!mounted) return;
      setState(() => _isScanning = true); //l'application est en cours de traitement
      
      //precuprer les outils providers
      final settingsProvider = context.read<SettingsProvider>();
      final scanProvider = context.read<ScanProvider>();
      scanProvider.setImage(File(pickedFile.path));
      
      final historyProvider = context.read<HistoryProvider>();
      
      await scanProvider.processImage( //traitement de l'image capturée par les services ml kit
        targetLanguage: settingsProvider.language,
        isSoundEnabled: settingsProvider.isSoundEnabled,
        isVibrationEnabled: settingsProvider.isVibrationEnabled,
      );

      // Sauvegarde automatique dans l'historique
      if (scanProvider.recognizedText.isNotEmpty) {
        historyProvider.addScan({
          'date': DateTime.now().toIso8601String(),
          'originalText': scanProvider.recognizedText,
          'detectedLanguage': scanProvider.detectedLanguage,
          'translatedText': scanProvider.translatedText,
          'targetLanguage': scanProvider.targetLanguage,
        });
      }
      //5. Navigation vers les résultats
      if (!mounted) return;
      setState(() => _isScanning = false);
      widget.onNavigate(ScreenType.results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SlideTransition(
      position: _slideAnim,
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onNavigate(ScreenType.home),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      l10n.scannerTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        ..._buildCorners(),
                        if (_isScanning)
                          _ScanningOverlay(label: l10n.scannerAnalysis)
                        else
                          _ScanLine(controller: _scanLineCtrl),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
              child: Column(
                children: [
                  Text(
                    l10n.scannerPrompt,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RoundIconButton(
                        icon: LucideIcons.image,
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isScanning ? 0.5 : 1.0,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF3B82F6),
                                width: 4,
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      _RoundIconButton(
                        icon: LucideIcons.camera,
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const color = Color(0xFF3B82F6);
    const size = 32.0;
    const thickness = 4.0;
    return [
      Positioned(top: 0, left: 0, child: _Corner(top: true, left: true, color: color, size: size, thickness: thickness)),
      Positioned(top: 0, right: 0, child: _Corner(top: true, left: false, color: color, size: size, thickness: thickness)),
      Positioned(bottom: 0, left: 0, child: _Corner(top: false, left: true, color: color, size: size, thickness: thickness)),
      Positioned(bottom: 0, right: 0, child: _Corner(top: false, left: false, color: color, size: size, thickness: thickness)),
    ];
  }
}

class _Corner extends StatelessWidget {
  final bool top;
  final bool left;
  final Color color;
  final double size;
  final double thickness;

  const _Corner({required this.top, required this.left, required this.color, required this.size, required this.thickness});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: thickness) : BorderSide.none,
          bottom: !top ? BorderSide(color: color, width: thickness) : BorderSide.none,
          left: left ? BorderSide(color: color, width: thickness) : BorderSide.none,
          right: !left ? BorderSide(color: color, width: thickness) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(24) : Radius.zero,
          topRight: top && !left ? const Radius.circular(24) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(24) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(24) : Radius.zero,
        ),
      ),
    );
  }
}

class _ScanLine extends StatelessWidget {
  final AnimationController controller;
  const _ScanLine({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final progress = t < 0.5 ? t * 2 : (1 - t) * 2;
        // Using Align + Transform to avoid ParentDataWidget issues in Stack
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(0, progress * 240), // Adjusted for box height
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScanningOverlay extends StatelessWidget {
  final String label;
  const _ScanningOverlay({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(24)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: Color(0xFF60A5FA), strokeWidth: 3)),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundIconButton({required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}