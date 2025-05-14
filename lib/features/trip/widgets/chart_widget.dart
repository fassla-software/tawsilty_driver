import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<Color> gradientColors = [
    const Color(0xFF00A08D),
    const Color(0x80FFFFFF),
  ];

  bool showAvg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          left: 0,
          right: 0,
          child: AspectRatio(
            aspectRatio: 1.95,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: GetBuilder<TripController>(
                    builder: (tripController) => LineChart(mainData(
                          tripController.earningChartList,
                          tripController.maxValue,
                        ))),
              ),
            ),
          )),
    ]);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final bool isToday = Get.find<TripController>().selectedOverview == 'today';
    const style = TextStyle(
        color: Color(0xff68737d), fontWeight: FontWeight.normal, fontSize: 10);

    Widget text;

    switch (value.toInt()) {
      case 0:
        text = const Text('', style: style);
        break;
      case 1:
        text = Text(isToday ? '6am' : 'Sun', style: style);
        break;
      case 2:
        text = Text(isToday ? '10am' : 'Mon', style: style);
        break;
      case 3:
        text = Text(isToday ? '2pm' : 'Tue', style: style);
        break;
      case 4:
        text = Text(isToday ? '6pm' : 'Wed', style: style);
        break;
      case 5:
        text = Text(isToday ? '10pm' : 'Thu', style: style);
        break;
      case 6:
        text = Text(isToday ? '2am' : 'Fri', style: style);
        break;
      case 7:
        text = Text(isToday ? '' : 'Sat', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String value = meta.formattedValue;

    if (value.toLowerCase().contains('k')) {
      value =
          '${PriceConverter.convertPrice(context, double.parse(value.toLowerCase().replaceAll('k', '')))}K';
    } else if (value.toLowerCase().contains('m')) {
      value =
          '${PriceConverter.convertPrice(context, double.parse(value.toLowerCase().replaceAll('m', '')))}M';
    } else {
      value = PriceConverter.convertPrice(
          context, double.parse(value.toLowerCase()));
    }

    return SideTitleWidget(
        meta: meta,
        child: Text(value,
            style: textRobotoRegular.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Color(0xff68737d))));
  }

  LineChartData mainData(List<FlSpot>? spots, double maxValue) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 0);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 0);
        },
      ),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          )),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 65,
            interval: maxValue / 5 <= 0 ? 1 : maxValue / 5,
          ))),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: maxValue,
      lineBarsData: [
        LineChartBarData(
          spots: spots ?? [],
          isCurved: true,
          barWidth: 1,
          isStrokeCapRound: true,
          color: Theme.of(context).primaryColor.withOpacity(0.50),
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors
                    .map((color) => color.withOpacity(0.20))
                    .toList()),
          ),
        ),
      ],
    );
  }
}
