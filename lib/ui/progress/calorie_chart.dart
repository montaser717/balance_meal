import 'package:balance_meal/common/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:balance_meal/services/calorie_tracking_service.dart';
import 'package:balance_meal/models/daily_calorie_entry.dart';

class CalorieChart extends StatefulWidget {
  const CalorieChart({super.key});

  @override
  State<CalorieChart> createState() => _CalorieChartState();
}

class _CalorieChartState extends State<CalorieChart> {
  int selectedDays = 90;
  final List<int> dayOptions = [30, 60, 90, 180, 365];
  List<DailyCalorieEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
    CalorieTrackingService.updated.addListener(_onUpdate);
  }

  void _onUpdate() {
    _loadHistory();
  }

  @override
  void dispose() {
    CalorieTrackingService.updated.removeListener(_onUpdate);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final loaded = await CalorieTrackingService().loadHistory(days: selectedDays);
    setState(() {
      entries = loaded;
    });
  }

  List<FlSpot> _createSpots(List<DailyCalorieEntry> entries, bool forGoal) {
    return entries.asMap().entries.map((e) {
      final y = forGoal ? e.value.goal : e.value.consumed;
      return FlSpot(e.key.toDouble(), y);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final goalSpots = _createSpots(entries, true);
    final actualSpots = _createSpots(entries, false);
    final allYValues = [...goalSpots, ...actualSpots].map((e) => e.y).toList();

    final minDataY = allYValues.isEmpty ? 0.0 : allYValues.reduce(min);
    final maxDataY = allYValues.isEmpty ? 3000.0 : allYValues.reduce(max);

    double adjustedMinY = ((minDataY / 100).floor() * 100).toDouble();
    double adjustedMaxY = ((maxDataY / 100).ceil() * 100 + 100).toDouble();

    if (adjustedMinY == adjustedMaxY) {
      adjustedMinY = max(0, adjustedMinY - 100);
      adjustedMaxY += 100;
    }


    final minY = max(0, adjustedMinY);
    final maxY = adjustedMaxY;
    final yStep = ((maxY - minY) / 4).floor();

    final goalLine = LineChartBarData(
      spots: goalSpots,
      isCurved: true,
      color: Colors.redAccent,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(colors: [Colors.redAccent.withOpacity(0.3), Colors.transparent]),
      ),
      dotData: FlDotData(show: true),
      barWidth: 3,
    );

    final consumedLine = LineChartBarData(
      spots: actualSpots,
      isCurved: true,
      color: Colors.teal,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(colors: [Colors.teal.withOpacity(0.3), Colors.transparent]),
      ),
      dotData: FlDotData(show: true),
      barWidth: 3,
    );

    final chartWidth = max(entries.length * 20.0, MediaQuery.of(context).size.width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.calories,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
              DropdownButton<int>(
                value: selectedDays,
                items: dayOptions.map((days) {
                  return DropdownMenuItem(
                    value: days,
                    child: Text("${(days / 30).round()} M"),
                  );
                }).toList(),
                onChanged: (value) async {
                  if (value != null) {
                    setState(() => selectedDays = value);
                    await _loadHistory();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.circle, color: Colors.teal, size: 14),
              const SizedBox(width: 4),
              Text(
                AppStrings.consumed,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.circle, color: Colors.redAccent, size: 14),
              const SizedBox(width: 4),
              Text(
                "Limit",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 48),
              child: Text("no data"),
            ),
          ),
        if (entries.isNotEmpty)
          SizedBox(
            height: 260,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: chartWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: entries.length.toDouble() - 1,
                    minY: 0,
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: (entries.length / 10).clamp(1, 14).floorToDouble(),
                          getTitlesWidget: (value, meta) {
                            final index = value.round();
                            if (index >= 0 && index < entries.length) {
                              final date = entries[index].date;
                              final textColor = Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87;
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    DateFormat('dd.MM').format(date),
                                    style: TextStyle(fontSize: 10, color: textColor),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          interval: yStep.toDouble(),
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()} kcal',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [goalLine, consumedLine],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.black,
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.all(8),
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          final date = entries[index].date;
                          final label = spot.bar.color == Colors.teal ? AppStrings.consumed : 'Limit';
                          return LineTooltipItem(
                            "$label: ${spot.y.toStringAsFixed(1)} kcal\n${DateFormat('dd.MM.yyyy').format(date)}",
                            TextStyle(
                              color: spot.bar.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
