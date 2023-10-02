import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_trash_mobile/data/bloc/trash/trash_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash_history/trash_history_bloc.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/data/models/trash_monitor.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GarbageMonitorDetail extends StatefulWidget {
  GarbageMonitorDetail({super.key});

  @override
  State<GarbageMonitorDetail> createState() => _GarbageMonitorDetailState();
}

class _GarbageMonitorDetailState extends State<GarbageMonitorDetail> {
  @override
  void initState() {
    super.initState();
    context.read<TrashHistoryBloc>().add(const GetTrashHistoryEvent());
  }

  void lockTrash(BuildContext context) {
    context.read<TrashBloc>().add(LockTrashEvent());
  }

  void unlockTrash(BuildContext context) {
    context.read<TrashBloc>().add(UnlockTrashEvent());
  }

  @override
  Widget build(BuildContext context) {
    final trash = ModalRoute.of(context)!.settings.arguments as TrashResponse;

    String wsUrl = dotenv.get("WS_URL");
    var channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    return Scaffold(
        appBar: AppBar(
          title: Text(trash.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // You can use any icon you prefer
            onPressed: () {
              context.read<TrashBloc>().add(GetAllTrashEvent());
              Navigator.pop(context); // To actually navigate back
            },
          ),
        ),
        body: SafeArea(
            child: Center(
                child: Container(
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

                      // TrashMonitor value = TrashMonitor.fromJson(jsonData);

                      return CircularPercentIndicator(
                        radius: 90,
                        lineWidth: 10,
                        percent: 0.1 * value / 10,
                        progressColor: (value >= 80)
                            ? Colors.red
                            : (value >= 60 && value <= 79)
                                ? Colors.yellow
                                : Colors.green,
                        center: Text(
                          value.toString() + "%",
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
              BlocConsumer<TrashBloc, TrashState>(
                builder: (context, state) {
                  bool isLoading = false;

                  if (state is LockTrashLoadingState ||
                      state is UnlockTrashErrorState) {
                    isLoading = true;
                  }

                  if (state is UnlockTrashSuccessState) {
                    isLoading = false;
                    trash.state = 1;
                  }

                  if (state is LockTrashSuccessState) {
                    isLoading = false;
                    trash.state = 0;
                  }
                  return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (trash.state == 0) {
                                    unlockTrash(context);
                                  }

                                  if (trash.state == 1) {
                                    lockTrash(context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  width: 2,
                                  color: trash.state == 0
                                      ? Colors.green
                                      : Colors.red),
                              backgroundColor: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.sizeOf(context).width * 0.3, 25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: (state is LockTrashLoadingState ||
                                  state is UnlockTrashLoadingState)
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: trash.state == 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              : Text(
                                  trash.state == 0 ? "Buka" : "Tutup",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: trash.state == 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )));
                },
                listener: (context, state) {
                  print(state);
                  if (state is LockTrashSuccessState ||
                      state is UnlockTrashSuccessState) {
                    // context.read<TrashBloc>().add(const GetTrashHistoryEvent());
                    // setState(() {});
                  }
                },
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: const Text(
                    "History Pembersihan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )),
              BlocConsumer<TrashHistoryBloc, TrashHistoryState>(
                builder: (context, state) {
                  if (state is GetTrashHistorySuccessState) {
                    List<DataRow> rows = [];

                    state.response.forEach(
                      (e) {
                        DataRow r = DataRow(cells: [
                          DataCell(Text(e.cleanedAt)),
                          DataCell(Container(
                            child: Text(
                              e.trash,
                              maxLines: 4,
                            ),
                          )),
                          DataCell(Text(e.cleanedBy))
                        ]);

                        rows.add(r);
                      },
                    );

                    return Flexible(
                      flex: 2,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            DataTable(
                                columnSpacing: 20,
                                dataRowMinHeight: 10,
                                dataRowMaxHeight: 50,
                                border: TableBorder(
                                    top: const BorderSide(width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    bottom: const BorderSide(width: 0.1)),
                                columns: const <DataColumn>[
                                  DataColumn(label: Text("Tanggal")),
                                  DataColumn(label: Text("Lokasi")),
                                  DataColumn(label: Text("Petugas"))
                                ],
                                rows: rows),
                          ],
                        ),
                      ),
                    );
                  }

                  return Flexible(
                    flex: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
                listener: (context, state) {},
              )
            ],
          ),
        ))));
  }
}
