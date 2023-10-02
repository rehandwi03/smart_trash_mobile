import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_trash_mobile/data/bloc/trash/trash_bloc.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
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
    context.read<TrashBloc>().add(GetAllTrashEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TrashResponse> trashes = [];
    return Scaffold(
        appBar: AppBar(
          title: Text("Monitoring Sampah"),
        ),
        body: SafeArea(
            child: BlocConsumer<TrashBloc, TrashState>(
          builder: (context, state) {
            if (state is GetAllTrashSuccessState) {
              trashes = state.response;
            }

            if (state is GetAllTrashLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: trashes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.garbageMonitorDetail,
                          arguments: trashes[index]);
                    },
                    child: card(context, trashes[index]),
                  );
                },
              ),
            );
          },
          listener: (context, state) {},
        )));
  }

  Widget card(BuildContext context, TrashResponse data) {
    String wsUrl = dotenv.get("WS_URL");
    var channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    return Container(
      width: 300,
      height: 200,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(1, 3),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 4,
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color:
                                  data.state == 0 ? Colors.green : Colors.red)),
                      alignment: Alignment.centerLeft,
                      child: Center(
                        child: Text(
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: data.state == 0 ? Colors.green : Colors.red,
                          ),
                          data.state == 0 ? "Terkunci" : "Terbuka",
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      StreamBuilder(
                        stream: channel.stream.asBroadcastStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> jsonData =
                                json.decode(snapshot.data);

                            int value = jsonData["data"];
                            int prefValue = 0;

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
