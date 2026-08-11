import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/city_repository.dart';
import '../models/city.dart';
import '../providers/app_settings.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';

/// شاشة اختيار المدينة — بحث فوري + تجميع حسب الدولة
class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  final _repo = CityRepository();
  final _controller = TextEditingController();

  List<City> _results = [];
  Map<String, List<City>> _grouped = {};
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = context.read<AppSettings>();
    final lang = settings.lang;
    final grouped = await _repo.groupByCountry(lang);
    final all = await _repo.load();
    if (!mounted) return;
    setState(() {
      _grouped = grouped;
      _results = all;
      _loading = false;
    });
  }

  void _onSearch(String q) async {
    final settings = context.read<AppSettings>();
    final results = await _repo.search(q, lang: settings.lang);
    if (!mounted) return;
    setState(() {
      _query = q;
      _results = results;
    });
  }

  void _select(City city) async {
    final provider = context.read<PrayerProvider>();
    await provider.selectCity(city);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final lang = settings.lang;
    final isDark = settings.darkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(lang == 'ar' ? 'اختيار المدينة' : 'Select City'),
        // شريط علوي بتأثير زجاجي (Blur) متدرج
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.55, 1.0],
                  colors: isDark
                      ? [
                          AppColors.darkBgTop.withOpacity(0.75),
                          AppColors.darkBgTop.withOpacity(0.35),
                          AppColors.darkBgTop.withOpacity(0.0),
                        ]
                      : [
                          AppColors.lightBgTop.withOpacity(0.75),
                          AppColors.lightBgTop.withOpacity(0.35),
                          AppColors.lightBgTop.withOpacity(0.0),
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: GradientBackground(
        isDark: isDark,
        child: Column(
          children: [
            // حقل البحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 8),
              child: TextField(
                controller: _controller,
                onChanged: _onSearch,
                style: TextStyle(
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: lang == 'ar'
                      ? 'ابحث عن مدينة أو دولة...'
                      : 'Search city or country...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMuted,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? AppColors.gold : AppColors.navy,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMuted,
                          ),
                          onPressed: () {
                            _controller.clear();
                            _onSearch('');
                          },
                        ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.07)
                      : Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.gold.withOpacity(0.25),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.gold.withOpacity(0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.gold.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _query.isNotEmpty
                  ? _buildSearchResults(lang)
                  : _buildGroupedList(lang, isDark),
            ),
          ],
        ),
      ),
    );
  }

  /// نتائج البحث المسطحة
  Widget _buildSearchResults(String lang) {
    if (_results.isEmpty) {
      return Center(
        child: Text(
          lang == 'ar' ? 'لا توجد نتائج' : 'No results',
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (_, i) => _CityTile(
        city: _results[i],
        lang: lang,
        onTap: () => _select(_results[i]),
      ),
    );
  }

  /// القائمة مجمّعة حسب الدولة
  Widget _buildGroupedList(String lang, bool isDark) {
    final countries = _grouped.keys.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: countries.length,
      itemBuilder: (_, i) {
        final country = countries[i];
        final cities = _grouped[country]!;
        return _CountrySection(
          country: country,
          cities: cities,
          lang: lang,
          onSelect: _select,
        );
      },
    );
  }
}

/// قسم دولة قابل للطي
class _CountrySection extends StatefulWidget {
  final String country;
  final List<City> cities;
  final String lang;
  final ValueChanged<City> onSelect;

  const _CountrySection({
    required this.country,
    required this.cities,
    required this.lang,
    required this.onSelect,
  });

  @override
  State<_CountrySection> createState() => _CountrySectionState();
}

class _CountrySectionState extends State<_CountrySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.country,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
                Text(
                  '${widget.cities.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          for (final city in widget.cities)
            _CityTile(
              city: city,
              lang: widget.lang,
              onTap: () => widget.onSelect(city),
            ),
      ],
    );
  }
}

/// صف مدينة واحد
class _CityTile extends StatelessWidget {
  final City city;
  final String lang;
  final VoidCallback onTap;

  const _CityTile({
    required this.city,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final isSelected = settings.cityId == city.id;

    return ListTile(
      leading: Icon(
        isSelected ? Icons.location_on : Icons.location_city,
        color: isSelected ? AppColors.gold : AppColors.textMuted,
      ),
      title: Text(city.name(lang)),
      subtitle: Text(city.country(lang)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.gold)
          : null,
      onTap: onTap,
    );
  }
}
