import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_trash_mobile/data/bloc/websocket/websocket_bloc.dart';
import 'package:smart_trash_mobile/data/models/trash_monitor.dart';
import 'package:smart_trash_mobile/routes.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GarbageMonitorScreen extends StatefulWidget {
  GarbageMonitorScreen({super.key});

  @override
  State<GarbageMonitorScreen> createState() => _GarbageMonitorScreenState();
}

class _GarbageMonitorScreenState extends State<GarbageMonitorScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String wsUrl = dotenv.get("WS_URL");
    print(wsUrl);
    var channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    return Scaffold(
      appBar: AppBar(title: Text("Monitoring Sampah")),
      body: BlocBuilder<WebsocketBloc, WebsocketState>(
        builder: (context, state) {
          return SafeArea(
              child: Center(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.garbageMonitorDetail);
                  },
                  child: card(context, channel),
                );
              },
            ),
          ));
        },
      ),
    );
  }

  Widget card(BuildContext context, WebSocketChannel channel) {
    return Container(
      width: 300,
      height: 200,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(1, 3),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 4,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    child: Text(
                      "Terkunci",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tempat Sampah 1",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      StreamBuilder(
                        stream: channel.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> jsonData =
                                json.decode(snapshot.data);

                            int value = jsonData["data"];
                            int prefValue = 0;

                            print(value);

                            if (value >= 100) {
                              value = 100;
                            }

                            if (value >= 0) {
                              prefValue = value;
                            }

                            if (value == 0) {
                              value = prefValue;
                            }

                            return CircularPercentIndicator(
                              radius: 50,
                              lineWidth: 10,
                              percent: 0.1 * value / 10,
                              progressColor: (value >= 80)
                                  ? Colors.red
                                  : (value >= 60 && value <= 79)
                                      ? Colors.yellow
                                      : Colors.green,
                              center: Text(
                                "${value}%",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            );
                          }

                          return CircularPercentIndicator(
                            radius: 50,
                            lineWidth: 5,
                            percent: 0,
                            center: Text("0"),
                          );
                        },
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
