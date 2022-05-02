[![pub package](https://img.shields.io/pub/v/persian.svg)](https://pub.dartlang.org/packages/persian)

Utilities and Humanizer for Persian language and culture.

## Features
* `PersianDate` class which converts a `DateTime` to Jalali date.
* String corrections replacing `ي` with `ی` and `ك` with `ک`.
* Humanize numbers to Persian text: 123 => صد و بیست و سه.
* Convert numbers to Persian numbers: 123 => ۱۲۳.
* Can be used in Dart and Flutter projects.
* Supports all platforms (Android, iOS, macOS, Windows, Linux, Web).


## Getting Started

In your `pubspec.yaml` file add:

```dart
dependencies:
  persian: any
```

## Usage

Import the package:

```dart
import 'package:persian/persian.dart';
```

Then, use the extension methods:

```dart
String myText = '123456789';
String myPersianText = myText.withPersianNumbers(); //Will be ۱۲۳۴۵۶۷۸۹
```

```dart
DateTime myDate = DateTime.now();
PersianDate myPersianDate = myDate.toPersian(); //Will be 1398/10/19
```

```dart
int number = 123456789;
String myPersianNumber = number.toPersianString(); //Will be صد و بیست و سه میلیون و چهارصد و پنجاه و شش هزار و هفتصد و هشتاد و نه
```
