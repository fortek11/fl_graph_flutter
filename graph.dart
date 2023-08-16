import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:gradient_like_css/gradient_like_css.dart' as gradient;

class ChartCard extends StatefulWidget {
  final List<FlSpot> dailySpots;
  final List<FlSpot> monthlySpots;
  final Function monthSelectedFunction;
  final Function downloadReportFunction;
  final double height;
  final double width;
  ChartCard(
      {required this.dailySpots,
      required this.monthlySpots,
      required this.monthSelectedFunction,
      required this.height,
      required this.width,
      required this.downloadReportFunction});
  @override
  State<ChartCard> createState() => _ChartCardState();
}

enum Filter { monthly, daily }

class _ChartCardState extends State<ChartCard> {
  DateTime? datePicked;

  Filter _filter = Filter.monthly;

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController(
        text:
            datePicked == null ? 'choose month' : datePicked!.month.toString());

    return Container(
      height: widget.height,
      width: widget.width,
      margin: const EdgeInsets.all(8),
      child: Card(
        shadowColor: Colors.deepPurple,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Total Members Attendance',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            Radio<Filter>(
                                value: Filter.daily,
                                fillColor: MaterialStateColor.resolveWith(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.deepPurple.withOpacity(0.7);
                                    }
                                    return Colors.grey.shade300;
                                  },
                                ),
                                groupValue: _filter,
                                onChanged: (value) {
                                  setState(() {
                                    _filter = value!;
                                  });
                                }),
                            const Text('Today\'s attendance')
                          ]),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(children: [
                            Radio<Filter>(
                                fillColor: MaterialStateColor.resolveWith(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.deepPurple.withOpacity(0.7);
                                    }
                                    return Colors.grey.shade300;
                                  },
                                ),
                                value: Filter.monthly,
                                groupValue: _filter,
                                onChanged: (value) {
                                  setState(() {
                                    _filter = value!;
                                  });
                                }),
                            const Text('Monthly attendance')
                          ])
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                          readOnly: true,
                          controller: _controller,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade600)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple.shade600)),
                              contentPadding: const EdgeInsets.all(8),
                              labelText: 'Date',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.deepPurple.shade600,
                                ),
                                onPressed: () {
                                  showMonthPicker(
                                    headerColor: Colors.deepPurple.shade500,
                                    headerTextColor: Colors.white,
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate: DateTime(DateTime.now().year,
                                        DateTime.now().month + 1, 0),
                                    roundedCornersRadius: 20,
                                    animationMilliseconds: 300,
                                    context: context,
                                    initialDate: DateTime.now(),
                                  ).then((date) {
                                    if (date == null) {
                                      return;
                                    }
                                    setState(() {
                                      datePicked = date;
                                    });
                                    widget.monthSelectedFunction(date);
                                  });
                                },
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.downloadReportFunction(_filter.index);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.cloud_download,
                              color: Colors.deepPurple.shade600,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Download report',
                              style:
                                  TextStyle(color: Colors.deepPurple.shade600),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              _filter == Filter.monthly
                  ? MonthlyAttandance(widget.monthlySpots)
                  : DailyAttandance(widget.dailySpots),
            ],
          ),
        ),
      ),
    );
  }
}


class MonthlyAttandance extends StatefulWidget {
  final List<FlSpot> _spots;
  const MonthlyAttandance(this._spots);

  @override
  State<MonthlyAttandance> createState() => _MonthlyAttandanceState();
}

class _MonthlyAttandanceState extends State<MonthlyAttandance> {
  List<Color> gradientColors = [
    Colors.deepPurple.withOpacity(0.9),
    Colors.deepPurple.withOpacity(0.9),
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
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      case 11:
        text = const Text('Dec', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 5:
        text = '5';
        break;
      case 10:
        text = '10';
        break;
      case 15:
        text = '15';
        break;
      case 20:
        text = '20';
        break;

      case 25:
        text = '25';
        break;
      case 30:
        text = '30';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.deepPurple,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map(
                  (lineBarSpot) {
                    double member = lineBarSpot.y;
                    double month = lineBarSpot.x;
                    String monthText;
                    switch (month) {
                      case 0:
                        monthText = 'Jan';
                        break;
                      case 1:
                        monthText = 'Feb';
                        break;
                      case 2:
                        monthText = 'Mar';
                        break;
                      case 3:
                        monthText = 'Apr';
                        break;
                      case 4:
                        monthText = 'May';
                        break;
                      case 5:
                        monthText = 'Jun';
                        break;
                      case 6:
                        monthText = 'Jul';
                        break;
                      case 7:
                        monthText = 'Aug';
                        break;
                      case 8:
                        monthText = 'Sep';
                        break;
                      case 9:
                        monthText = 'Oct';
                        break;
                      case 10:
                        monthText = 'Nov';
                        break;
                      case 11:
                        monthText = 'Dec';
                        break;
                      default:
                        monthText = '';
                    }
                    return LineTooltipItem(
                      'Total members: ${member}\n  ${monthText}',
                      TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ).toList();
              })),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            dashArray: [10, 8],
            color: Colors.black12,
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
          show: true, border: Border.all(color: Colors.grey.shade100)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 35,
      lineBarsData: [
        LineChartBarData(
          spots: widget._spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1.2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
              show: true,
              gradient: gradient
                  .linearGradient(180, ['#BDB3FF', '#F0E6FF', 'white'])),
        ),
      ],
    );
  }
}

class DailyAttandance extends StatefulWidget {
  final List<FlSpot> _spots;
  const DailyAttandance(this._spots);

  @override
  State<DailyAttandance> createState() => _DailyAttandanceState();
}

class _DailyAttandanceState extends State<DailyAttandance> {
  List<Color> gradientColors = [
    Colors.deepPurple.withOpacity(0.9),
    Colors.deepPurple.withOpacity(0.9),
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
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('8 am', style: style);
        break;
      case 1:
        text = const Text('9 am', style: style);
        break;
      case 2:
        text = const Text('10 am', style: style);
        break;
      case 3:
        text = const Text('11 am', style: style);
        break;
      case 4:
        text = const Text('12 pm', style: style);
        break;
      case 5:
        text = const Text('1 pm', style: style);
        break;
      case 6:
        text = const Text('2 pm', style: style);
        break;
      case 7:
        text = const Text('3 pm', style: style);
        break;
      case 8:
        text = const Text('4 pm', style: style);
        break;
      case 9:
        text = const Text('5 pm', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 5:
        text = '5';
        break;
      case 10:
        text = '10';
        break;
      case 15:
        text = '15';
        break;
      case 20:
        text = '20';
        break;

      case 25:
        text = '25';
        break;
      case 30:
        text = '30';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.deepPurple,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map(
                  (lineBarSpot) {
                    double member = lineBarSpot.y;
                    double time = lineBarSpot.x;
                    String timeText;
                    switch (time) {
                      case 0:
                        timeText = '8 am';
                        break;
                      case 1:
                        timeText = '9 am';
                        break;
                      case 2:
                        timeText = '10 am';
                        break;
                      case 3:
                        timeText = '11 am';
                        break;
                      case 4:
                        timeText = '12 pm';
                        break;
                      case 5:
                        timeText = '1 pm';
                        break;
                      case 6:
                        timeText = '2 pm';
                        break;
                      case 7:
                        timeText = '3 pm';
                        break;
                      case 8:
                        timeText = '4 pm';
                        break;
                      case 9:
                        timeText = '5 pm';
                        break;
                      default:
                        timeText = '';
                    }
                    return LineTooltipItem(
                      'Total members: ${member}\n  ${timeText}',
                      TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ).toList();
              })),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            dashArray: [10, 8],
            color: Colors.black12,
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
          show: true, border: Border.all(color: Colors.grey.shade100)),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 35,
      lineBarsData: [
        LineChartBarData(
          spots: widget._spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1.2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
              show: true,
              gradient: gradient
                  .linearGradient(180, ['#BDB3FF', '#F0E6FF', 'white'])),
        ),
      ],
    );
  }
}


