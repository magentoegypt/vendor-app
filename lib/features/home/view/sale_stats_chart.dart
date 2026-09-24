
import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          // BarChartRodData(
          //   toY: y1,
          //   color: Colors.blue,
          //   width: size,
          //   borderRadius: const BorderRadius.only(
          //     topRight: Radius.circular(1.0),
          //     topLeft: Radius.circular(1.0),
          //   ),
          // ),
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

  @override
  Widget build(BuildContext context) {
    var barChartGroupDataList = <BarChartGroupData>[];
    if (saleStats != null) {
      for (int index = 0;index<saleStats!.length;index++){
        barChartGroupDataList.add(makeGroupData(
            index,
            0,
            (saleStats![index].numberOfOrder ?? 0).toDouble()));
      }

    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
      child:Container(
      height: 260,
      width: (saleStats?.length ?? 0)*70 < MediaQuery.of(context).size.width - 30 ? MediaQuery.of(context).size.width-30:(saleStats?.length ?? 0)*70,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.0),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Colors.grey)),
      child: BarChart(
        BarChartData(
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
                getTitlesWidget: (double value, TitleMeta meta) =>
                    bottomTitles(value, meta, context),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                /// Comment code to avoid related issue - https://github.com/imaNNeo/fl_chart/issues/1210
                /// Texts are showing with provided [interval].
                /// If you don't provide anything, we try to find a suitable value to set as [interval] under the hood.
                //interval: 40,
                getTitlesWidget: (double value, TitleMeta meta) =>
                    leftTitles(context, value, meta),
              ),
            ),
          ),
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(
              border: const Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          )),
          barGroups: barChartGroupDataList,
          gridData: const FlGridData(
              drawHorizontalLine: true, drawVerticalLine: false),
          alignment: BarChartAlignment.spaceAround,
        ),
      )
      ),
    );
  }

  Widget leftTitles(BuildContext context, double value, TitleMeta meta) {

    Widget axisTitle = Text(value.toString(),
        style: const TextStyle(
          fontSize: 11,
        ));
    if (value == meta.max) {
      final remainder = value % meta.appliedInterval;
      if (remainder != 0.0 && remainder / meta.appliedInterval < 0.5) {
        axisTitle = const SizedBox.shrink();
      }
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: axisTitle);
  }

  Widget bottomTitles(double value, TitleMeta meta, BuildContext context) {
    final Widget text = Text(
      saleStats?[value.toInt()].time ?? "",
      style: TextStyle(
        fontSize: 9,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 7, //margin top
      child: text,
    );
  }
}
