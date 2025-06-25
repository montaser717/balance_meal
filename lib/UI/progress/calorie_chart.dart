import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class CalorieChart extends StatefulWidget {
  const CalorieChart({super.key});

  @override
  State<CalorieChart> createState() => _CalorieChartState();
}

class _CalorieChartState extends State<CalorieChart> {
  int selectedDays = 90;
  final List<int> dayOptions = [30, 60, 90, 180, 365];

  List<DateTime> generateDates(int days) {
    return List.generate(days, (i) => DateTime.now().subtract(Duration(days: days - i)));
  }

  List<FlSpot> generateCalorieData(List<DateTime> dates, int base, {int variation = 200}) {
    final rand = Random();
    return List.generate(dates.length, (i) => FlSpot(i.toDouble(), (base + rand.nextInt(variation)).toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    final dates = generateDates(selectedDays);
    final goalSpots = generateCalorieData(dates, 2200, variation: 100);
    final actualSpots = generateCalorieData(dates, 2100, variation: 300);

    final allYValues = [...goalSpots, ...actualSpots].map((e) => e.y);
    final minY = (allYValues.reduce(min) / 100).floor() * 100 - 100;
    final maxY = (allYValues.reduce(max) / 100).ceil() * 100 + 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kalorien', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<int>(
                value: selectedDays,
                items: dayOptions.map((days) {
                  return DropdownMenuItem(
                    value: days,
                    child: Text("${(days / 30).round()} Monate"),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedDays = value);
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
            children: const [
              Icon(Icons.circle, color: Colors.teal, size: 14),
              SizedBox(width: 4),
              Text("Verbrauch", style: TextStyle(fontSize: 15)),
              SizedBox(width: 12),
              Icon(Icons.circle, color: Colors.redAccent, size: 14),
              SizedBox(width: 4),
              Text("Limit", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(((maxY - minY) ~/ 200 + 1), (i) {
                    final yVal = maxY - i * 200;
                    return Text('$yVal kcal', style: const TextStyle(fontSize: 10));
                  }),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: max(dates.length * 20.0, MediaQuery.of(context).size.width),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade50, Colors.grey.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: dates.length.toDouble() - 1,
                        minY: minY.toDouble(),
                        maxY: maxY.toDouble(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 7,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < dates.length) {
                                  final date = dates[index];
                                  return Transform.rotate(
                                    angle: -0.4,
                                    child: Text('${date.day}.${date.month}', style: const TextStyle(fontSize: 10)),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: goalSpots,
                            isCurved: true,
                            color: Colors.redAccent,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(colors: [Colors.redAccent.withOpacity(0.3), Colors.transparent]),
                            ),
                            dotData: FlDotData(show: true),
                            barWidth: 3,
                          ),
                          LineChartBarData(
                            spots: actualSpots,
                            isCurved: true,
                            color: Colors.teal,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(colors: [Colors.teal.withOpacity(0.3), Colors.transparent]),
                            ),
                            dotData: FlDotData(show: true),
                            barWidth: 3,
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            tooltipRoundedRadius: 8,
                            tooltipPadding: const EdgeInsets.all(8),
                            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                              final index = spot.x.toInt();
                              final date = dates[index];
                              return LineTooltipItem(
                                "${spot.bar.color == Colors.teal ? 'Verbrauch' : 'Limit'}: ${spot.y.toStringAsFixed(1)} kcal\n${DateFormat('dd.MM.yyyy').format(date)}",
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
          ),
        ),
      ],
    );
  }
}
