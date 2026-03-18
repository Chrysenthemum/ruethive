class ScheduleItem {
  final String subject;
  final String courseCode;
  final String teacher;
  final String room;
  final String startTime;
  final String endTime;
  final String? day;
  final int colorHex;

  ScheduleItem({
    required this.subject,
    required this.courseCode,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
    this.day,
    required this.colorHex,
  });

  // Add these methods:
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'courseCode': courseCode,
      'teacher': teacher,
      'room': room,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
      'colorHex': colorHex,
    };
  }

  factory ScheduleItem.fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      subject: map['subject'] ?? '',
      courseCode: map['courseCode'] ?? '',
      teacher: map['teacher'] ?? '',
      room: map['room'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      day: map['day'],
      colorHex: map['colorHex'] ?? 0xFF000000,
    );
  }
}