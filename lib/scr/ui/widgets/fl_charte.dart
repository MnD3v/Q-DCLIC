import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/colors.dart';
import 'package:immobilier_apk/scr/config/app/fonts.dart';
import 'package:my_widgets/widgets/text.dart';

class LineChartSample2 extends StatefulWidget {
  final List<double> points;
  const LineChartSample2({super.key, required this.points});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    AppColors.color500,
    AppColors.coffee,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
           mainData(widget.points),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = EText('1', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 1:
        text = EText('2', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 2:
        text = EText('3', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 3:
        text = EText('4', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 4:
        text = EText('5', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 5:
        text = EText('6', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 6:
        text = EText('7', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 7:
        text = EText('8', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 8:
        text = EText('9', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;
      case 9:
        text = EText('10', color: Colors.pinkAccent, font: Fonts.sevenSegment);
        break;

      default:
        text = EText('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
        fontFamily: Fonts.sevenSegment, fontSize: 15, color: Colors.white);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;

      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<double> points) {
    var spots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i]));
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 12,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.color500,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.coffee,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: points.length.toDouble(),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }


}
