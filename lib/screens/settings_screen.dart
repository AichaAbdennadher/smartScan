import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../types.dart';

class SettingsScreen extends StatelessWidget {
  final ValueChanged<ScreenType> onNavigate;
  const SettingsScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.settingsSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Section : Apparence & Langue ──
            _SectionHeader(label: l10n.settingsAppearance, isDark: isDark),
            const SizedBox(height: 12),

            _ToggleRow(
              icon: Icons.dark_mode_outlined,
              label: l10n.darkMode,
              checked: settings.isDarkMode,
              isDark: isDark,
              onChange: (v) => context.read<SettingsProvider>().toggleDarkMode(v),
            ),

            const SizedBox(height: 8),

            _LanguageRow(
              isDark: isDark,
              label: l10n.interfaceLanguage,
              currentLanguage: settings.language,
              onChanged: (lang) {
                if (lang != null) {
                  context.read<SettingsProvider>().setLanguage(lang);
                }
              },
            ),

            const SizedBox(height: 24),

            // ── Section : Préférences ──
            _SectionHeader(label: l10n.settingsPreferences, isDark: isDark),
            const SizedBox(height: 12),

            _ToggleRow(
              icon: Icons.volume_up_outlined,
              label: l10n.soundEffects,
              checked: settings.isSoundEnabled,
              isDark: isDark,
              onChange: (v) => context.read<SettingsProvider>().toggleSound(v),
            ),

            _ToggleRow(
              icon: Icons.smartphone_outlined,
              label: l10n.vibrations,
              checked: settings.isVibrationEnabled,
              isDark: isDark,
              onChange: (v) => context.read<SettingsProvider>().toggleVibration(v),
            ),

            const SizedBox(height: 24),

            // ── Section : Application ──
            _SectionHeader(label: l10n.settingsApp, isDark: isDark),
            const SizedBox(height: 12),

            _NavRow(
              icon: Icons.info_outline,
              label: l10n.about,
              isDark: isDark,
              onTap: () => onNavigate(ScreenType.about),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool checked;
  final bool isDark;
  final ValueChanged<bool> onChange;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.checked,
    required this.isDark,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _rowDecoration(isDark),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _IconBox(icon: icon, isDark: isDark),
            const SizedBox(width: 12),
            Expanded(child: _RowLabel(label: label, isDark: isDark)),
            Material(
              color: Colors.transparent,
              child: Switch(
                value: checked,
                onChanged: onChange,
                activeColor: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final bool isDark;
  final String label;
  final String currentLanguage;
  final ValueChanged<String?> onChanged;

  const _LanguageRow({
    required this.isDark,
    required this.label,
    required this.currentLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _rowDecoration(isDark),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _IconBox(icon: Icons.language_outlined, isDark: isDark),
            const SizedBox(width: 12),
            Expanded(child: _RowLabel(label: label, isDark: isDark)),
            Material(
              color: Colors.transparent,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentLanguage,
                  isDense: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B82F6),
                  ),
                  dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _rowDecoration(isDark),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _IconBox(icon: icon, isDark: isDark),
              const SizedBox(width: 12),
              Expanded(child: _RowLabel(label: label, isDark: isDark)),
              const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionHeader({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _IconBox({required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 20,
        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
      ),
    );
  }
}

class _RowLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _RowLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    );
  }
}

BoxDecoration _rowDecoration(bool isDark) {
  return BoxDecoration(
    color: isDark ? const Color(0xFF1E293B) : Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
    ),
  );
}