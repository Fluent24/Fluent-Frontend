import 'package:intl/intl.dart';

class DateTimeUtil {
  // 'yyyy-MM-dd HH-MM:00.000' -> 'yyyy-MM-dd' 형식으로 변경
  static String formatDateTime(DateTime value) {
    return DateFormat('yyyy-MM-dd').format(value);
  }

  /// 날짜를 'MM/dd' 형식으로 변환하고 앞에 0을 제거하는 함수
  static String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MM-dd');
    String formattedDate = formatter.format(date);

    List<String> dateParts = formattedDate.split('-');
    String month = dateParts[0];
    String day = dateParts[1];

    if (month.startsWith('0')) {
      month = month.substring(1);
    }

    if (day.startsWith('0')) {
      day = day.substring(1);
    }

    return '$month/$day';
  }
}

class TierUtil {
  static String tierMapping(int tier) {
    String tierName = '';

    switch (tier) {
      case 1:
        tierName = 'bronze';
        break;
      case 2:
        tierName = 'silver';
        break;
      case 3:
        tierName = 'gold';
        break;
      case 4:
        tierName = 'diamond';
        break;
      case 5:
        tierName = 'master';
        break;
      default:
        break;
    }

    return tierName;
  }
}

class FavoriteUtils {
  static List<String> makeNullList(dynamic value) {
    if (value == null) {
      return [];
    }

    if (value is List) {
      return List<String>.from(value);
    }

    throw ArgumentError('[ERR] Expected a List but got $value');
  }
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}