import 'package:example/example.dart' as example;

void main(List<String> arguments) {
  final date = DateTime(2021, 5, 8);
  final persianDate = example.convertDateTime(date);

  print('$persianDate');
}
