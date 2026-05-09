import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import '../providers/history_provider.dart';
import '../providers/settings_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All';
  bool _isSelectionMode = false;
  final Set<int> _selectedIndices = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredHistory(List<Map<String, dynamic>> history) {
    final now = DateTime.now();
    return history.where((scan) {
      // Date filter
      if (_activeFilter != 'All') {
        final dateStr = scan['date'] as String?;
        if (dateStr == null) return false;
        final ts = DateTime.parse(dateStr);
        
        if (_activeFilter == 'Today' || _activeFilter == 'Aujourd\'hui' || _activeFilter == 'اليوم') {
          if (ts.year != now.year || ts.month != now.month || ts.day != now.day) return false;
        } else if (_activeFilter == 'This Week' || _activeFilter == 'Cette semaine' || _activeFilter == 'هذا الأسبوع') {
          final weekAgo = now.subtract(const Duration(days: 7));
          if (ts.isBefore(weekAgo)) return false;
        } else if (_activeFilter == 'This Month' || _activeFilter == 'Ce mois' || _activeFilter == 'هذا الشهر') {
          if (ts.year != now.year || ts.month != now.month) return false;
        }
      }
      
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final original = (scan['originalText'] ?? '').toString().toLowerCase();
        final translated = (scan['translatedText'] ?? '').toString().toLowerCase();
        return original.contains(q) || translated.contains(q);
      }
      return true;
    }).toList();
  }

  Future<void> _confirmClear(BuildContext context, HistoryProvider provider, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.navHistory),
        content: Text(_selectedIndices.isEmpty 
            ? l10n.deleteConfirmAll
            : l10n.deleteConfirmSelected),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.close),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF3B82F6)),
            child: Text(_selectedIndices.isEmpty ? l10n.deleteAll : l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (_selectedIndices.isEmpty) {
        provider.clearHistory();
      } else {
        // Map filtered indices back to original indices in provider.history
        final fullHistory = provider.history.reversed.toList();
        final filteredHistory = _getFilteredHistory(fullHistory);
        
        final List<int> indicesToDelete = [];
        for (final index in _selectedIndices) {
          final scan = filteredHistory[index];
          // Find original index in provider.history
          final originalIndex = provider.history.indexOf(scan);
          if (originalIndex != -1) {
            indicesToDelete.add(originalIndex);
          }
        }
        
        provider.deleteScans(indicesToDelete);
        setState(() {
          _selectedIndices.clear();
          _isSelectionMode = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    
    final fullHistory = historyProvider.history.reversed.toList();
    final filteredHistory = _getFilteredHistory(fullHistory);

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final List<String> filters = [
      settings.language == 'ar' ? 'الكل' : (settings.language == 'fr' ? 'Tout' : 'All'),
      settings.language == 'ar' ? 'اليوم' : (settings.language == 'fr' ? 'Aujourd\'hui' : 'Today'),
      settings.language == 'ar' ? 'هذا الأسبوع' : (settings.language == 'fr' ? 'Cette semaine' : 'This Week'),
      settings.language == 'ar' ? 'هذا الشهر' : (settings.language == 'fr' ? 'Ce mois' : 'This Month'),
    ];

    if (_activeFilter == 'All' || _activeFilter == 'Tout' || _activeFilter == 'الكل') {
      _activeFilter = filters[0];
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filters
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.historyTitle,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      if (fullHistory.isNotEmpty)
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(LucideIcons.listChecks, 
                                color: _isSelectionMode ? const Color(0xFF3B82F6) : subtitleColor, 
                                size: 20),
                              onPressed: () => setState(() => _isSelectionMode = !_isSelectionMode),
                            ),
                            IconButton(
                              icon: Icon(
                                _selectedIndices.isEmpty ? LucideIcons.trash2 : LucideIcons.trash, 
                                color: const Color(0xFF3B82F6), 
                                size: 20
                              ),
                              onPressed: () => _confirmClear(context, historyProvider, l10n),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(color: titleColor),
                    decoration: InputDecoration(
                      hintText: settings.language == 'ar' ? 'البحث عن المسحات...' : (settings.language == 'fr' ? 'Rechercher...' : 'Search past scans...'),
                      hintStyle: TextStyle(color: subtitleColor),
                      prefixIcon: Icon(LucideIcons.search, color: subtitleColor, size: 20),
                      filled: true,
                      fillColor: cardColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((f) {
                        final selected = f == _activeFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: selected,
                            onSelected: (_) => setState(() => _activeFilter = f),
                            backgroundColor: cardColor,
                            selectedColor: const Color(0xFF3B82F6),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : subtitleColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            side: BorderSide(color: selected ? Colors.transparent : borderColor),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: filteredHistory.isEmpty
                  ? _buildEmptyState(isDark, l10n, _searchQuery.isNotEmpty)
                  : ListView.separated(// pour afficher chaque scan sous forme de carte élégante.
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                      itemCount: filteredHistory.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final scan = filteredHistory[index];
                        final dateStr = scan['date'] as String?;
                        final date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
                        final formattedDate = DateFormat('dd MMM yyyy', settings.language).format(date);

                        return _HistoryCard(
                          scan: scan,
                          dateStr: formattedDate,
                          isDark: isDark,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          titleColor: titleColor,
                          subtitleColor: subtitleColor,
                          isSelectionMode: _isSelectionMode,
                          isSelected: _selectedIndices.contains(index),
                          onSelect: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedIndices.add(index);
                              } else {
                                _selectedIndices.remove(index);
                              }
                            });
                          },
                          onTap: _isSelectionMode 
                            ? () {
                                setState(() {
                                  if (_selectedIndices.contains(index)) {
                                    _selectedIndices.remove(index);
                                  } else {
                                    _selectedIndices.add(index);
                                  }
                                });
                              }
                            : () => _showDetails(context, scan, formattedDate, isDark, l10n),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n, bool hasQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasQuery ? LucideIcons.searchX : LucideIcons.history,
            size: 64,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 16),
          Text(
            hasQuery ? 'Aucun résultat trouvé' : l10n.noHistory,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> scan, String date, bool isDark, AppLocalizations l10n) {
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.scanDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                              child: Text(date, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _DetailSection(
                      label: '${l10n.detectedText} (${scan['detectedLanguage'] ?? '...'})', 
                      content: scan['originalText'] ?? '', 
                      icon: LucideIcons.scanText, 
                      isDark: isDark
                    ),
                    const SizedBox(height: 24),
                    if (scan['translatedText'] != null && scan['translatedText'].isNotEmpty)
                      _DetailSection(
                        label: '${l10n.translation} (${scan['targetLanguage'] ?? '...'})', 
                        content: scan['translatedText'], 
                        icon: LucideIcons.languages, 
                        isDark: isDark, 
                        highlight: true
                      ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(l10n.close, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> scan;
  final String dateStr;
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?> onSelect;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.scan, 
    required this.dateStr, 
    required this.isDark, 
    required this.cardColor, 
    required this.borderColor, 
    required this.titleColor, 
    required this.subtitleColor, 
    required this.isSelectionMode,
    required this.isSelected,
    required this.onSelect,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: onSelect,
                activeColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: const Icon(LucideIcons.fileText, color: Color(0xFF3B82F6), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3B82F6))),
                  const SizedBox(height: 4),
                  Text(scan['originalText'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor)),
                  if (scan['translatedText'] != null && scan['translatedText'].isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(scan['translatedText'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: subtitleColor)),
                  ],
                ],
              ),
            ),
            if (!isSelectionMode)
              Icon(LucideIcons.chevronRight, size: 20, color: subtitleColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String label;
  final String content;
  final IconData icon;
  final bool isDark;
  final bool highlight;

  const _DetailSection({required this.label, required this.content, required this.icon, required this.isDark, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: highlight ? const Color(0xFF3B82F6) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
            const SizedBox(width: 8),
            Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: highlight ? const Color(0xFF3B82F6) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
          child: Text(content, style: TextStyle(fontSize: 15, height: 1.5, color: isDark ? Colors.white : const Color(0xFF0F172A))),
        ),
      ],
    );
  }
}
