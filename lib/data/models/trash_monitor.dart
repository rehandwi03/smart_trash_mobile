class TrashMonitor {
  String type;
  int data;

  TrashMonitor({required this.type, required this.data});

  factory TrashMonitor.fromJson(Map<String, dynamic> json) {
    return TrashMonitor(type: json["type"], data: int.parse(json["data"]));
  }
}
