import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:balance_meal/common/app_theme.dart';
import 'package:balance_meal/common/app_strings.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import '../../models/weight_entry.dart';
import 'calorie_chart.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();

}

class _ProgressViewState extends State<ProgressView> {
  String selectedRange = '3 Monate';
  late Box<WeightEntry> weightBox;

  @override
  void initState() {
    super.initState();
    weightBox = Hive.box<WeightEntry>('weightBox');
  }

  List<Map<String, dynamic>> _weightsFromBox(Box<WeightEntry> box) {
    final list = box.values
        .map((e) => {'date': e.date, 'weight': e.weight})
        .toList();
    list.sort((a, b) =>
        (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    return list;
  }

  List<Map<String, dynamic>> _filteredWeights(List<Map<String, dynamic>> weights) {
    final now = DateTime.now();
    switch (selectedRange) {
      case '1 Monat':
        return weights.where((e) => e['date'].isAfter(now.subtract(const Duration(days: 30)))).toList();
      case '2 Monate':
        return weights.where((e) => e['date'].isAfter(now.subtract(const Duration(days: 60)))).toList();
      case '3 Monate':
        return weights.where((e) => e['date'].isAfter(now.subtract(const Duration(days: 90)))).toList();
      case '6 Monate':
        return weights.where((e) => e['date'].isAfter(now.subtract(const Duration(days: 180)))).toList();
      case '1 Jahr':
        return weights.where((e) => e['date'].isAfter(now.subtract(const Duration(days: 365)))).toList();
      case 'Alle':
      default:
        return weights;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<WeightEntry>>(
      valueListenable: weightBox.listenable(),
      builder: (context, box, _) {
        final allWeights = _weightsFromBox(box);
        if (allWeights.isEmpty) {
          return Center(child: Text(AppStrings.noWeights));
        }

        final weights = _filteredWeights(allWeights);
        final firstDate = weights.first['date'] as DateTime;
        final allValues = weights.map((e) => e['weight'] as double);
        final minY = (allValues.reduce(min) - 0.5).floorToDouble();
        final maxY = (allValues.reduce(max) + 0.5).ceilToDouble();

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
                const Text("Gewicht", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: selectedRange,
                      items: ['1 Monat', '2 Monate', '3 Monate', '6 Monate', '1 Jahr', 'Alle']
                          .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedRange = value!),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing * 0.75),
                SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.only(left: AppTheme.spacing),
                width: max(spots.length * 24.0, MediaQuery.of(context).size.width),
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (value, _) => Text("${value.toStringAsFixed(0)} kg", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 3,
                          getTitlesWidget: (value, _) {
                            final date = firstDate.add(Duration(days: value.toInt()));
                            return Transform.rotate(
                              angle: -0.4,
                              child: Text(DateFormat('dd.MM').format(date), style: const TextStyle(fontSize: 10)),
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
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: Colors.teal,
                          ),
                        ),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3AD29F), Color(0xFF438AF3)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF3AD29F).withValues(alpha: 0.3),
                              const Color(0xFF438AF3).withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.black87,
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.all(8),
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
            const SizedBox(height: 32),
            CalorieChart(),
          ],
        ),
      ),
        );
      },
    );
  }

}

