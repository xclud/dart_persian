# persian
[![pub package](https://img.shields.io/pub/v/persian.svg)](https://pub.dartlang.org/packages/persian)

Implements helper functions/extensions for Persian language/culture. Includes number replacement methods for String class and PersianDate class.

## Getting Started

**Import the package**

```dart
import 'package:persian/persian.dart';
```

**Use the extension methods**
```dart
String myText = '123456789';
String myPersianText = myText.withPersianNumbers(); //Will be ۱۲۳۴۵۶۷۸۹
```

```dart
DateTime myDate = DateTime.now();
PersianDate myPersianDate = myDate.toPersian(); //Will be 1398/10/19
```
