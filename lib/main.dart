import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'HomePal'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _refreshSensorStatuses() {
    final random = Random();
    final int sensorsToUpdate = random.nextInt(3) + 1; // 1 to 3 sensors
    for (int i = 0; i < sensorsToUpdate; i++) {
      final int sensorIndex = random.nextInt(_data.length);
      setState(() {
        _data[sensorIndex]['status'] =
            _data[sensorIndex]['status'] == 'online' ? 'offline' : 'online';
      });
    }
  }

  Future<void> _loadData() async {
    final String response =
        await rootBundle.loadString('assets/mock_data.json');
    final data = await json.decode(response);
    setState(() {
      _data = data['sensors']; // Access the "sensors" list
    });
  }

  Widget _buildSummary() {
    int onlineCount =
        _data.where((sensor) => sensor['status'] == 'online').length;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$onlineCount/${_data.length} sensors online',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBarChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 200, // Set a fixed height for the bar chart
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: _data.map((sensor) {
              return BarChartGroupData(
                x: _data.indexOf(sensor),
                barRods: [
                  BarChartRodData(
                    toY: sensor['uptime'].toDouble(),
                    color: Colors.lightGreen,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text('${value.toInt()}%');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _data[value.toInt()]['name'],
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withValues(alpha: 50),
                  dashArray: [5, 5],
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _data.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  _buildSummary(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            _data[index]['status'] == 'online'
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _data[index]['status'] == 'online'
                                ? Colors.green
                                : Colors.grey,
                          ),
                          title: Text(_data[index]['name']),
                          subtitle: Text(
                              'Status: ${_data[index]['status']}, Uptime: ${_data[index]['uptime']}%'),
                        );
                      },
                    ),
                  ),
                  _buildBarChart(), // Add the bar chart here
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshSensorStatuses,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
