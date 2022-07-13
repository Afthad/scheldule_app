class SchedulerDTO {
  String name;
  DateTime startTime;
  DateTime endTime;
  DateTime date;
  String phoneNumber;
  SchedulerDTO({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime.microsecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'date': date.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
    };
  }

  factory SchedulerDTO.fromMap(Map<String, dynamic> map) {
    return SchedulerDTO(
      name: map['name'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
