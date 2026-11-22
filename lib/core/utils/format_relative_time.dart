String formatRelativeTime(DateTime dateTime, {DateTime? now}) {
  final difference = (now ?? DateTime.now()).difference(dateTime);

  if (difference.isNegative || difference.inSeconds < 60) {
    return 'just now';
  }

  if (difference.inMinutes < 60) {
    return _timeUnit(difference.inMinutes, 'min');
  }

  if (difference.inHours < 24) {
    return _timeUnit(difference.inHours, 'hour');
  }

  if (difference.inDays < 30) {
    return _timeUnit(difference.inDays, 'day');
  }

  if (difference.inDays < 365) {
    return _timeUnit(difference.inDays ~/ 30, 'month');
  }

  return _timeUnit(difference.inDays ~/ 365, 'year');
}

String _timeUnit(int value, String unit) =>
    '$value $unit${value == 1 ? '' : 's'} ago';
