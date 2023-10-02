class TrashResponse {
  int id;
  String name;
  int state;

  TrashResponse({required this.id, required this.name, required this.state});

  factory TrashResponse.fromJson(Map<String, dynamic> json) {
    return TrashResponse(
        id: json["id"], name: json["name"], state: json["state"]);
  }
}

class ReportPerDay {
  int data;

  ReportPerDay({required this.data});

  factory ReportPerDay.fromJson(Map<String, dynamic> json) {
    return ReportPerDay(data: json["data"]);
  }
}

class TrashHistory {
  int id;
  String trash;
  String cleanedAt;
  String cleanedBy;

  TrashHistory(
      {required this.id,
      required this.trash,
      required this.cleanedAt,
      required this.cleanedBy});

  factory TrashHistory.fromJson(Map<String, dynamic> json) {
    return TrashHistory(
        id: json["id"],
        trash: json["trash"],
        cleanedAt: json["cleaned_at"],
        cleanedBy: json["cleaned_by"]);
  }
}
