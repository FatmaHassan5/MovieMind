/// أدوات التواريخ (من غير أي package خارجي): أسماء الشهور، المقارنة، والتسميات النسبية.
abstract class AppDates {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// أول حرف من كل يوم، والأسبوع بيبدأ بالأحد.
  static const weekdayInitials = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime daysFromToday(int days) {
    final t = today();
    return DateTime(t.year, t.month, t.day + days);
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static String monthName(int month) => _months[month - 1];

  static String shortMonth(int month) => _months[month - 1].substring(0, 3);

  static String monthYear(DateTime d) => '${monthName(d.month)} ${d.year}';

  static String shortDate(DateTime d) => '${shortMonth(d.month)} ${d.day}, ${d.year}';

  static int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  /// عدد الأيام من النهارده لحد التاريخ (بالـ UTC عشان تتفادي مشاكل التوقيت الصيفي).
  static int daysUntil(DateTime d) {
    final t = today();
    return DateTime.utc(d.year, d.month, d.day)
        .difference(DateTime.utc(t.year, t.month, t.day))
        .inDays;
  }

  static String relative(DateTime d) {
    final diff = daysUntil(d);
    if (diff < 0) return 'Released';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff <= 60) return 'In $diff days';
    return 'In ${diff ~/ 30} months';
  }
}
