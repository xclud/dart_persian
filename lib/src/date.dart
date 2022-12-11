part of persian;

int _getJulianDayNumber(int year, int month, int day) {
  return (((year + ((month - 8) ~/ 6) + 100100) * 1461) ~/ 4) +
      ((153 * ((month + 9) % 12) + 2) ~/ 5) +
      day -
      34840408 -
      ((((year + 100100 + ((month - 8) ~/ 6)) ~/ 100) * 3) ~/ 4) +
      752;
}

/// An instant in Persian calendar, such as Farvardin 11, 1365.
class PersianDate {
  /// Creates a [PersianDate] from the Persian year, month and day.
  ///
  /// Example: PersianDate(1400, 12, 29);
  const PersianDate(
    this.year,
    this.month,
    this.day,
  );

  /// Creates a [PersianDate] from the equivalent [DateTime].
  factory PersianDate.fromDateTime(DateTime date) {
    final julianDayNumber =
        _getJulianDayNumber(date.year, date.month, date.day);
    final int year = date.year;
    int persianYear = year - 621;
    final r = _PersianDateCalculation.calculate(persianYear);
    final int jdn1f = _getJulianDayNumber(year, 3, r.march);
    int k = julianDayNumber - jdn1f;
    // Find number of days that passed since 1 Farvardin.
    if (k >= 0) {
      if (k <= 185) {
        // The first 6 months.
        final int jm = 1 + (k ~/ 31);
        final int jd = (k % 31) + 1;

        return PersianDate(persianYear, jm, jd);
      } else {
        // The remaining months.
        k -= 186;
      }
    } else {
      // Previous Persian year.
      persianYear -= 1;
      k += 179;
      if (r.leap == 1) k += 1;
    }
    final int jm = 7 + (k ~/ 30);
    final int jd = (k % 30) + 1;

    return PersianDate(persianYear, jm, jd);
  }

  /// Constructs a new [PersianDate] instance
  /// with the given [millisecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [PersianDate] represents
  /// 1970-01-01T00:00:00Z + [millisecondsSinceEpoch] ms in the given
  /// time zone (local or UTC).
  ///
  factory PersianDate.fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,
  }) =>
      PersianDate.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(
          millisecondsSinceEpoch,
          isUtc: isUtc,
        ),
      );

  /// Constructs a new [PersianDate] instance
  /// with the given [microsecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [PersianDate] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  factory PersianDate.fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    bool isUtc = false,
  }) =>
      PersianDate.fromDateTime(
        DateTime.fromMicrosecondsSinceEpoch(
          microsecondsSinceEpoch,
          isUtc: isUtc,
        ),
      );

  /// The Year.
  final int year;

  /// The Month.
  final int month;

  /// The Day.
  final int day;

  @override
  String toString() {
    return '$year/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}'
        .withPersianNumbers();
  }
}

/// Internal class
class _PersianDateCalculation {
  const _PersianDateCalculation({
    required this.leap,
    required this.gy,
    required this.march,
  });

  /// This determines if the Persian Year is
  /// leap (366-day long) or is the common year (365 days), and
  /// finds the day in March (Gregorian calendar) of the first
  /// day of the Persian Year.
  ///
  /// [1. see here](http://www.astro.uni.torun.pl/~kb/Papers/EMP/PersianC-EMP.htm)
  ///
  /// [2. see here](http://www.fourmilab.ch/documents/calendar/)
  factory _PersianDateCalculation.calculate(int persianYear) {
    // Persian years starting the 33-year rule.

    final int bl = breaks.length;
    final int gy = persianYear + 621;
    int leapJ = -14;
    int jp = breaks[0];
    int jump = 0;

    // should not happen
    if (persianYear < -61 || persianYear >= 3178) {
      throw StateError('should not happen');
    }

    // Find the limiting years for the Persian year jy.
    for (int i = 1; i < bl; i += 1) {
      final int jm = breaks[i];
      jump = jm - jp;
      if (persianYear < jm) {
        break;
      }
      leapJ = leapJ + (jump ~/ 33) * 8 + (((jump % 33)) ~/ 4);
      jp = jm;
    }
    int n = persianYear - jp;

    // Find the number of leap years from AD 621 to the beginning
    // of the current Persian year in the Persian calendar.
    leapJ = leapJ + ((n) ~/ 33) * 8 + (((n % 33) + 3) ~/ 4);
    if ((jump % 33) == 4 && jump - n == 4) {
      leapJ += 1;
    }

    // And the same in the Gregorian calendar (until the year gy).
    final int leapG = ((gy) ~/ 4) - (((((gy) ~/ 100) + 1) * 3) ~/ 4) - 150;

    // Determine the Gregorian date of Farvardin the 1st.
    final int march = 20 + leapJ - leapG;

    // Find how many years have passed since the last leap year.
    if (jump - n < 6) {
      n = n - jump + ((jump + 4) ~/ 33) * 33;
    }
    int leap = ((((n + 1) % 33) - 1) % 4);
    if (leap == -1) {
      leap = 4;
    }

    return _PersianDateCalculation(leap: leap, gy: gy, march: march);
  }

  /// Number of years since the last leap year (0 to 4)
  final int leap;

  /// Gregorian year of the beginning of Persian year
  final int gy;

  /// The March day of Farvardin the 1st (1st day of jy)
  final int march;

  static final List<int> breaks = const [
    -61,
    9,
    38,
    199,
    426,
    686,
    756,
    818,
    1111,
    1181,
    1210,
    1635,
    2060,
    2097,
    2192,
    2262,
    2324,
    2394,
    2456,
    3178,
  ];
}
