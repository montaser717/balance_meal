import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:balance_meal/common/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../common/app_strings.dart';
import '../../models/weight_entry.dart';
import '../../services/hive_profile_service.dart';
import '../../services/weight_service.dart';
import '../progress//calorie_chart.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  late final WeightService _weightService;
  List<Map<String, dynamic>> _allWeights = [];
  String _selectedRange = '1 W';

  @override
  void initState() {
    super.initState();
    _weightService = WeightService(HiveProfileService());
    _loadWeights();
  }

  Future<void> _loadWeights() async {
    final weights = await _weightService.loadWeightsFilled(days:360);
    setState(() {
      _allWeights = weights;
    });
  }

  Future<void> _saveWeight(double newWeight, {DateTime? date}) async {
    final entryDate = date ?? DateTime.now();
    final normalized = DateTime(entryDate.year, entryDate.month, entryDate.day);

    final newEntry = WeightEntry(date: normalized, weight: newWeight);
    await _weightService.addOrUpdateEntry(newEntry);


    if (DateUtils.isSameDay(normalized, DateTime.now())) {
      final profileService = HiveProfileService();
      final currentProfile = await profileService.loadProfile();
      if (currentProfile != null) {
        await profileService.saveProfile(currentProfile.copyWith(weight: newWeight));
      }
    }

    await _loadWeights();
  }


  void _showWeightInput({DateTime? date, double? initialValue}) {
    showDialog<double>(
      context: context,
      builder: (_) => WeightInputDialog(initialValue: initialValue),
    ).then((value) {
      if (value != null) {
        _saveWeight(value, date: date);
      }
    });
  }

  double get xAxisInterval {
    switch (_selectedRange) {
      case '1 W':
        return 1;
      case '1 M':
        return 3;
      case '2 M':
        return 6;
      case '3 M':
        return 7.5;
      case '6 M':
        return 15;
      case '1 Y':
        return 30;
      default:
        return 15;
    }
  }

  List<Map<String, dynamic>> get filteredWeights {
    final now = DateTime.now();
    switch (_selectedRange) {
      case "1 W":
        return _allWeights.where((e) => (e['date'] as DateTime).isAfter(now.subtract(const Duration(days: 7)))).toList();
      case '1 M':
        return _allWeights.where((e) => (e['date'] as DateTime).isAfter(now.subtract(const Duration(days: 30)))).toList();
      case '2 M':
        return _allWeights.where((e) => (e['date'] as DateTime).isAfter(now.subtract(const Duration(days: 60)))).toList();
      case '3 M':
        return _allWeights.where((e) => (e['date'] as DateTime).isAfter(now.subtract(const Duration(days: 90)))).toList();
      case '6 M':
        return _allWeights.where((e) => (e['date'] as DateTime).isAfter(now.subtract(const Duration(days: 180)))).toList();
      case '1 Y':
        return _allWeights.where((e) => (e['date'] as DateTime).isAfter(now.subtract(const Duration(days: 365)))).toList();

      default:
        return _allWeights;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weights = filteredWeights;
    double minY = 0;
    double maxY = 0;
    final firstDate = weights.isNotEmpty ? weights.first['date'] as DateTime : DateTime.now();
    final allValues = weights.map((e) => e['weight'] as double);
    minY = weights.isNotEmpty ? (allValues.reduce(min) - 2).floorToDouble() : 0;
    maxY = weights.isNotEmpty ? (allValues.reduce(max) + 2).ceilToDouble() : 100;

    final spots = weights.map((e) {
      final days = (e['date'] as DateTime).difference(firstDate).inDays.toDouble();
      return FlSpot(days, e['weight'] as double);
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.progress, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacing * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.weight, style: Theme.of(context).textTheme.titleMedium),
                DropdownButton<String>(
                  value: _selectedRange,
                  items: ['1 W', '1 M', '2 M', '3 M', '6 M', '1 Y']
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedRange = value!),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.only(left: AppTheme.spacing),
                width: max(spots.length * 35.0, MediaQuery.of(context).size.width),
                height: 280,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    minX: 0,
                    maxX: spots.isNotEmpty ? spots.last.x + 2 : 10,
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (value, _) => Text(
                            "${value.toStringAsFixed(0)} kg",
                            style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade700),
                          ),

                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: xAxisInterval,
                          getTitlesWidget: (value, _) {
                            final date = firstDate.add(Duration(days: value.toInt()));
                            return Transform.rotate(
                              angle: -0.4,
                              child: Text(
                                DateFormat('dd.MM').format(date),
                                style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.black87),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: spots,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3AD29F), Color(0xFF438AF3)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [Color(0xFF3AD29F).withOpacity(0.3), Color(0xFF438AF3).withOpacity(0.1)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (event, response) {
                        if (event is FlTapUpEvent && response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
                          final touchedSpot = response.lineBarSpots!.first;
                          final index = touchedSpot.x.toInt();
                          final touchedWeight = weights[index]['weight'] as double;
                          final touchedDate = weights[index]['date'] as DateTime;
                          _showWeightInput(date: touchedDate, initialValue: touchedWeight);
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.grey.shade900,
                        tooltipRoundedRadius: 10,
                        tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipMargin: 8,
                        getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                          final date = firstDate.add(Duration(days: spot.x.toInt()));
                          return LineTooltipItem(
                            "${spot.y.toStringAsFixed(1)} kg\n${DateFormat('dd.MM').format(date)}",
                            const TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(AppStrings.tracking),
                onPressed: () => _showWeightInput(),
              ),
            ),
            const SizedBox(height: 32),
            CalorieChart(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class WeightInputDialog extends StatefulWidget {
  final double? initialValue;
  const WeightInputDialog({super.key, this.initialValue});

  @override
  State<WeightInputDialog> createState() => _WeightInputDialogState();
}

class _WeightInputDialogState extends State<WeightInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toStringAsFixed(1) ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(AppStrings.entrWeight, style: theme.textTheme.titleMedium),
      content: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: AppStrings.example,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          prefixIcon: const Icon(Icons.monitor_weight_outlined),
          filled: true,
          fillColor: theme.cardColor.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child:  Text(AppStrings.cancel)),
        ElevatedButton(
          onPressed: () {
            final weight = double.tryParse(_controller.text);
            if (weight != null) Navigator.pop(context, weight);
          },
          child:  Text(AppStrings.save),
        ),
      ],
    );
  }
}
