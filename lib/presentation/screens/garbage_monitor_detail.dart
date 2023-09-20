import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_trash_mobile/data/models/trash_monitor.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GarbageMonitorDetail extends StatefulWidget {
  GarbageMonitorDetail({super.key});

  @override
  State<GarbageMonitorDetail> createState() => _GarbageMonitorDetailState();
}

class _GarbageMonitorDetailState extends State<GarbageMonitorDetail> {
  @override
  Widget build(BuildContext context) {
    String wsUrl = dotenv.get("WS_URL");
    var channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    return Scaffold(
        appBar: AppBar(
          title: Text("Tempat Sampah 1"),
        ),
        body: SafeArea(
            child: Center(
                child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> jsonData =
                          json.decode(snapshot.data);

                      TrashMonitor value = TrashMonitor.fromJson(jsonData);

                      return CircularPercentIndicator(
                        radius: 90,
                        lineWidth: 10,
                        percent: 0.1 * value.data / 10,
                        progressColor: (value.data >= 80)
                            ? Colors.red
                            : (value.data >= 60 && value.data <= 79)
                                ? Colors.yellow
                                : Colors.green,
                        center: Text(
                          value.data.toString() + "%",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      );
                    }

                    return CircularPercentIndicator(
                      radius: 90,
                      lineWidth: 5,
                      percent: 0,
                      progressColor: Colors.green,
                      center: Text("0 %"),
                    );
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Buka",
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.sizeOf(context).width * 0.3, 25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "History Pembersihan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )),
              Flexible(
                flex: 2,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: [
                      DataTable(
                          border: TableBorder(
                              top: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              bottom: BorderSide(width: 0.1)),
                          columns: <DataColumn>[
                            DataColumn(label: Text("Tanggal")),
                            DataColumn(label: Text("Lokasi")),
                            DataColumn(label: Text("Petugas"))
                          ],
                          rows: <DataRow>[
                            DataRow(cells: [
                              DataCell(Text('02-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Rehan Dwi'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                            DataRow(cells: [
                              DataCell(Text('03-06-2023 15:34')),
                              DataCell(Text('Tempat Sampah 1')),
                              DataCell(Text('Laksono'))
                            ]),
                          ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ))));
  }
}
