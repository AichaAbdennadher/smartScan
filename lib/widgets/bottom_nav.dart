import 'package:flutter/material.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import '../types.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class BottomNav extends StatelessWidget {
  final ScreenType currentScreen;
  final ValueChanged<ScreenType> onNavigate;

  const BottomNav({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (currentScreen == ScreenType.scan || currentScreen == ScreenType.about) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tabs = [
      {'id': ScreenType.home, 'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': l10n.navHome},
      {'id': ScreenType.scan, 'icon': Icons.document_scanner_outlined, 'activeIcon': Icons.document_scanner, 'label': l10n.navScan},
      {'id': ScreenType.history, 'icon': Icons.history_outlined, 'activeIcon': Icons.history, 'label': l10n.navHistory},
      {'id': ScreenType.settings, 'icon': Icons.settings_outlined, 'activeIcon': Icons.settings, 'label': l10n.navSettings},
    ];

    final List<ScreenType> tabOrder = tabs.map((t) => t['id'] as ScreenType).toList();
    int currentIndex = tabOrder.indexOf(currentScreen);
    if (currentIndex == -1) {
      if (currentScreen == ScreenType.results) currentIndex = 1; // Map results to scan
      else currentIndex = 0;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => onNavigate(tabOrder[index]),
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: tabs.map((tab) => BottomNavigationBarItem(
        icon: Icon(tab['icon'] as IconData),
        activeIcon: Icon(tab['activeIcon'] as IconData),
        label: tab['label'] as String,
      )).toList(),
    );
  }
}

class _TabItem {
  final ScreenType id;
  final IconData icon;
  final String label;

  const _TabItem({
    required this.id,
    required this.icon,
    required this.label,
  });
}
