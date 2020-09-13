extension IntExtensions on int {
  String toPersianString({String separator = ' و '}) {
    return _toPersianString(this, separator);
  }
}

final _tensNames = [
  '',
  'ده',
  'بیست',
  'سی',
  'چهل',
  'پنجاه',
  'شصت',
  'هفتاد',
  'هشتاد',
  'نود'
];

final _numNames = [
  '',
  'یک',
  'دو',
  'سه',
  'چهار',
  'پنج',
  'شش',
  'هفت',
  'هشت',
  'نه',
  'ده',
  'یازده',
  'دوازده',
  'سیزده ',
  'چهارده',
  'پانزده',
  'شانزده',
  'هفده',
  'هجده',
  'نوزده'
];

final _hundredNames = [
  'صد',
  'دویست',
  'سیصد',
  'چهارصد',
  'پانصد',
  'ششصد',
  'هفتصد',
  'هشتصد',
  'نهصد'
];

String _convertLessThanOneThousand(int number, String separator) {
  int n = number;
  final parts = <String>[];

  if (n % 100 < 20) {
    parts.add(_numNames[n % 100]);
    n ~/= 100;
  } else {
    parts.add(_numNames[n % 10]);
    n ~/= 10;
    parts.add(_tensNames[n % 10]);
    n ~/= 10;
  }
  if (n > 0) {
    parts.add(_hundredNames[n - 1]);
  }

  return parts.reversed.join(separator);
}

String _toPersianString(int number, String separator) {
  if (number == 0) {
    return 'صفر';
  }

  final parts = <String>[];

  final sNumber = number.toString().padLeft(12, '0');
  final billions = int.parse(sNumber.substring(0, 3));
  final millions = int.parse(sNumber.substring(3, 6));
  final hundredThousands = int.parse(sNumber.substring(6, 9));
  final thousands = int.parse(sNumber.substring(9, 12));

  if (billions != 0) {
    final b = _convertLessThanOneThousand(billions, separator);
    parts.add('$b میلیارد');
  }

  if (millions > 0) {
    final m = _convertLessThanOneThousand(millions, separator);
    parts.add('$m میلیون');
  }

  if (hundredThousands > 0) {
    final t = _convertLessThanOneThousand(hundredThousands, separator);
    parts.add('$t هزار');
  }

  final s = _convertLessThanOneThousand(thousands, separator);
  parts.add(s);

  final result = parts.join(' و ');
  return result;
}
