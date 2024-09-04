import 'package:flutter/material.dart';
import 'dart:async';
import 'graph_page.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert' show utf8;

class RecordScreen extends StatefulWidget {
  final Stream<List<int>> stream;
  final BluetoothDevice device;

  const RecordScreen({Key? key, required this.device, required this.stream}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  List<double> recordedValues = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startRecording();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startRecording() {
    setState(() {
      recordedValues.clear();
    });

    widget.stream.listen((data) {
      var currentValue = _dataParser(data);
      recordedValues.add(double.tryParse(currentValue) ?? 0);
    });

    timer = Timer(Duration(minutes: 1), () {
      stopRecording();
      navigateToGraphPage();
    });
  }

  void stopRecording() {
    timer?.cancel();
  }

  void navigateToGraphPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraphPage(device: widget.device, recordedValues: recordedValues),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked : (didPop) {
          if (didPop) {
            return;
          }
        },
    child: Scaffold(
      appBar: AppBar(
        title: Text('Stream Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recording...',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    ));
  }
}