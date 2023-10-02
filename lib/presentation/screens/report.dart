import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash/trash_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash_history/trash_history_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    context.read<TrashHistoryBloc>().add(const GetTrashHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    // final histories = context.select((TrashBloc bloc) => bloc.histories);

    return Scaffold(
      appBar: AppBar(title: const Text("Laporan")),
      body: SafeArea(
        child: BlocBuilder<TrashHistoryBloc, TrashHistoryState>(
          builder: (context, state) {
            print("state: ${state}");

            if (state is GetTrashHistorySuccessState) {
              List<DataRow> rows = [];
              state.response.forEach((e) {
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
              });

              return buildTable(context, rows);
            }

            if (state is GetTrashHistoryLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final selectedDate = args.value as PickerDateRange;
    print(selectedDate);

    startDate = selectedDate.startDate;
    endDate = selectedDate.endDate;
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            title: Text("Pilih Tanggal"),
            content: Container(
                margin: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width,
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                )),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue),
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // to go back to screen after submitting
                  }),
              ElevatedButton(
                  child: Text("Save"),
                  onPressed: () {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      context.read<TrashHistoryBloc>().add(GetTrashHistoryEvent(
                          startDate: startDate, endDate: endDate));
                      Navigator.pop(context);
                    });
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget datePicker() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Material(
        elevation: 1,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Shadow color
                spreadRadius: 1, // How wide the shadow should be
                blurRadius: 3, // How blurry the shadow should be
                // offset: const Offset(0, 5), // Offset of the shadow
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showDialog(context),
            child: const AbsorbPointer(
              child: TextField(
                // controller: textController,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: 'Filter Berdasarkan Tanggal',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  // pass the hint text parameter here
                  hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTable(BuildContext context, List<DataRow> rows) {
    return Container(
      child: Column(
        children: [
          datePicker(),
          DataTable(
              columnSpacing: 20,
              dataRowMinHeight: 10,
              dataRowMaxHeight: 50,
              border: TableBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  bottom: BorderSide(width: 0.1)),
              columns: const <DataColumn>[
                DataColumn(label: Text("Tanggal")),
                DataColumn(label: Text("Lokasi")),
                DataColumn(label: Text("Petugas"))
              ],
              rows: rows)
        ],
      ),
    );
  }
}
