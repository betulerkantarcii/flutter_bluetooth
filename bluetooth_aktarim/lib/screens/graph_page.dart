import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_aktarim/main.dart';

class GraphPage extends StatelessWidget {
  final List<double> recordedValues;
  final BluetoothDevice device;

  GraphPage({required this.device, required this.recordedValues});


  @override
  Widget build(BuildContext context) {
    print(recordedValues.length);
    return PopScope(
        canPop: false,
        onPopInvoked : (didPop) {
      if (didPop) {
        return;
      }
    },
    child:Scaffold(
      appBar: AppBar(
        title: Text('Graph Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          recordedValues.length,
                              (index) => FlSpot(
                            index.toDouble() / (recordedValues.length - 1) * 60,
                            recordedValues[index],
                          ),
                        ),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ),
           Expanded(
              flex:1,
              child:Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  device.disconnect();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {return HomePage();}), (route) => false);
                },
                child: Text('Turn Back'),
              ),
            )),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    ));
  }
}
