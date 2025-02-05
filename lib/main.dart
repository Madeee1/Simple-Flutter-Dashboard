import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'HomePal'),
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
