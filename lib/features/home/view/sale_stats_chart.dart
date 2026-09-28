
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/DashboarModel.dart';


class SaleStatsChart extends StatelessWidget {
  final List<OrderChartData>? saleStats;

  const SaleStatsChart({super.key, this.saleStats});

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    var size = 10.0;
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y2,
          color: Colors.blue,
          width: size,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(1.0),
            topLeft: Radius.circular(1.0),
          ),
        ),
      ],
    );
  }

  /// Whole-number steps for an order count, about five of them: 1 up to 5
  /// orders, then 2, 3, ...
  static double orderStep(num highest) =>
      math.max(1, (highest / 5).ceil()).toDouble();

  /// "2026-9-27" -> "9-27": the year is the same on every bar and made the
  /// labels too wide to fit a week across the card.
  static String shortDate(String? date) =>
      RegExp(r'^\d{4}-(.+)$').firstMatch(date ?? '')?.group(1) ?? (date ?? '');

  /// Whether bar [index] of [count] gets a date: every bar up to ten days,
  /// otherwise every n-th counting back from the latest, which always does.
  static bool labelsDay(int index, int count) =>
      (count - 1 - index) % math.max(1, (count / 10).ceil()) == 0;

  @override
  Widget build(BuildContext context) {
    final stats = saleStats ?? const <OrderChartData>[];
    final groups = [
      for (var i = 0; i < stats.length; i++)
        makeGroupData(i, 0, (stats[i].numberOfOrder ?? 0).toDouble()),
    ];
    final highest = stats.fold<num>(0, (m, day) => math.max(m, day.numberOfOrder ?? 0));
    final step = orderStep(highest);

    // The whole range fits the card: it used to scroll sideways, opening on
    // the oldest days in English and scrolling the Y axis out of view in
    // Arabic. Dates run left to right in both languages.
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.0),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Colors.grey)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: math.max(step, (highest / step).ceil() * step),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  getTitlesWidget: (double value, TitleMeta meta) =>
                      bottomTitles(value, meta, context, stats),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: step,
                  getTitlesWidget: leftTitles,
                ),
              ),
            ),
            barTouchData: BarTouchData(enabled: false),
            borderData: FlBorderData(
                border: const Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            )),
            barGroups: groups,
            gridData: FlGridData(
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: step),
            alignment: BarChartAlignment.spaceAround,
          ),
        ),
      ),
    );
  }

  /// Order counts: whole numbers only ("3", not "3.0").
  Widget leftTitles(double value, TitleMeta meta) {
    if (value != value.roundToDouble()) return const SizedBox.shrink();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 11)),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta, BuildContext context,
      List<OrderChartData> stats) {
    final index = value.toInt();
    if (index < 0 || index >= stats.length || !labelsDay(index, stats.length)) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 7, //margin top
      child: Text(
        shortDate(stats[index].time),
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
