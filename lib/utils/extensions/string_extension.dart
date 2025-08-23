import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String? convertToTime() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.jm().format(dateFormat);
  }

  String? convertToDate() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.MMMd().format(dateFormat);
  }

  String? convertToFullDate() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.yMMMd().format(dateFormat);
  }

  String? differenceDay() {
    DateTime dateFormat = DateTime.parse(this);
    final date = Jiffy.parseFromDateTime(DateTime.now())
        .diff(Jiffy.parseFromDateTime(dateFormat), unit: Unit.day)
        .toString();
    if (date == "0") {
      return "Today";
    }
    if (date == "1") {
      return "Yesterday";
    }
    return "$date Days ago";
  }

  String? differenceHour() {
    DateTime dateFormat = DateTime.parse(this);
    final hours = Jiffy.parseFromDateTime(DateTime.now())
        .diff(Jiffy.parseFromDateTime(dateFormat), unit: Unit.hour)
        .toString();
    return "$hours Hours ago";
  }

  String cardSyntaxToFullDate() {
    DateTime dateTime = DateFormat("MM/yy").parse(this);
    String fullMonthYear = DateFormat.yMMMM("en_US").format(dateTime);
    return fullMonthYear;
  }
}
