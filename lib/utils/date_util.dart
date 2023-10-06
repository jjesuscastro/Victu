import 'package:intl/intl.dart';

class DateUtil {
  static DateTime getReferenceMonday() {
    DateTime now = DateTime.now();

    //if today is Sunday, change now to tomorrow, Monday
    if (now.weekday == 7) now = now.add(const Duration(days: 1));

    //To get weekStart (Monday), subtract weekday-1 from today
    //Example: today is Thursday, which has a value of 4. To get 1: 4-1 = 3 then 4 - 3 = 1
    DateTime weekStart = now.subtract(Duration(days: (now.weekday - 1)));

    return weekStart;
  }

  static Day getOrderDate() {
    DateTime orderDate = DateTime.now();

    orderDate = orderDate.add(const Duration(days: 1));

    // if (orderDate.weekday == 7) {
    //   orderDate = orderDate.add(const Duration(days: 1));
    //   return Day(getWeekdayString(orderDate.weekday), orderDate,
    //       formatDate(orderDate));
    // }

    // if (orderDate.hour > 12) {
    //   do {
    //     orderDate = orderDate.add(const Duration(days: 1));
    //   } while (orderDate.weekday == 7);
    // }

    return Day(
        getWeekdayString(orderDate.weekday), orderDate, formatDate(orderDate));
  }

  ///Get the Day object of a specified weekday (Monday = 1, Tuesday = 2...)
  static Day getDay(int dayToGet) {
    DateTime day = getReferenceMonday().add(Duration(days: (dayToGet - 1)));
    return Day(getWeekdayString(day.weekday), day, formatDate(day));
  }

  /// Checks if date string is today. Date string must be MMMM DD, yyyy
  static bool checkToday(String date) {
    DateTime now = DateTime.now();
    DateTime orderDate = parseDate(date);

    return now.compareTo(orderDate) <= 0;
  }

  ///Gets tomorrow
  static Day getTomorrow() {
    DateTime now = DateTime.now();

    DateTime tmrw = now.add(const Duration(days: 1));
    if (tmrw.weekday == 7) {
      tmrw = tmrw.add(const Duration(days: 1));
    }

    String weekday = getWeekdayString(tmrw.weekday);

    return Day(weekday, tmrw, formatDate(tmrw));
  }

  ///Get today
  static Day getToday() {
    DateTime now = DateTime.now();
    String weekday = getWeekdayString(now.weekday);
    return Day(weekday, now, formatDate(now));
  }

  ///Converts DateTime to String MMMM DD, yyyy
  static String formatDate(DateTime date) => DateFormat.yMMMMd().format(date);

  static String getWeekdayFromDate(String date) =>
      getWeekdayString(parseDate(date).weekday);

  static DateTime parseDate(String date) =>
      DateFormat("MMMM DD, yyyy").parse(date);

  ///Converts weekday int to String (1 = Monday, 2 = Tuesday, ...)
  static String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }
}

class Day {
  final String weekday;
  final DateTime date;
  final String formattedDate;

  Day(this.weekday, this.date, this.formattedDate);
}
