import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash/trash_bloc.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TrashBloc>().add(GetTrashHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan")),
      body: SafeArea(
        child: BlocBuilder<TrashBloc, TrashState>(
          builder: (context, state) {
            print(state);
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

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget buildTable(BuildContext context, List<DataRow> rows) {
    return DataTable(
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
        rows: rows);
  }
}
