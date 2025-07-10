import 'package:test/test.dart';

void main() {
  test('add num', () {
    expect(calculateString(''), 0);
    expect(calculateString('1'), 1);
    expect(calculateString('1,5'), 6);
    expect(calculateString("1,\n2,3"), 'invalid');
    expect(calculateString("1\n2,3"), 6);
    expect(calculateString("1,\n2,3"), 'invalid');
    expect(calculateString('/'), 'invalid');
    expect(calculateString('0'), 0);
    expect(calculateString('00'), 00);
    expect(calculateString('1,'), 'invalid');
    expect(calculateString('11'), 11);
    expect(calculateString('1,'), 'invalid');
    expect(calculateString('11@@2,3'), 'invalid');
    expect(calculateString('//@\n11@23'), 34);
    expect(calculateString('//@\n2'), 2);
    expect(calculateString('//@\n1,2'), 'invalid');
    expect(calculateString('//@@\n11@@23'), 34);
    expect(calculateString('1,\n2'), 'invalid');
    expect(calculateString('1\n2'), 3);


    print(calc('11@23', customDelimiter: '@'));
  });
}

/// so as per reading i find out only comma separated and new lines are allow
/// so if it find any other im just throwing invalid
/// for custom should followed by //
calculateString(dynamic val) {
  try {
    //"1,\n,2,3"
    String input = '$val';
    bool customDelimiter = false;
    //check for delimiters at first two char
    if (input.isEmpty) return 0;
    if (input.length == 1 && int.tryParse(input[0]).runtimeType == int) {
      return int.tryParse(input[0]);
    } else if (input.length == 1) {
      return 'invalid';
    } else if (input.length == 2) {
      int? first = int.tryParse(input[0]);
      int? second = int.tryParse(input[1]);
      if (first.runtimeType == int && second.runtimeType == int) {
        return int.tryParse('$first$second');
      } else {
        return 'invalid';
      }
    } else if (input.length > 2 && input[0] == '/' && input[1] == '/') {
      customDelimiter = true;
    }
    if (customDelimiter) {
      String delimiter = '';
      String val = '';
      for (int i = 2; i < input.length; i++) {
        if (input[i] != '\n') {
          delimiter += input[i];
        } else {
          if (i != input.length) {
            val = input.substring(i + 1, input.length);
            print('this is val $val');
          } else {
            return 'invalid';
          }
          print(val);
          print(delimiter);
          break;
        }
      }
      return calc(val, customDelimiter: delimiter);
    } else {
      return calc(input);
    }
  } catch (e) {
    print('Error while calculating the values $e');
    return 'error';
  }
  // return finalVal;
}

dynamic calc(String val, {String? customDelimiter}) {
  print(customDelimiter);
  if (val.isEmpty) return 'invalid';
  // final delimiters = [',', '\n',"@@"];
  List<String> delimiters =
      (customDelimiter ?? '').isNotEmpty && customDelimiter != null
          ? [customDelimiter]
          : [
              ',',
              '\n',
            ];
  if (int.tryParse(val[0]) == null ||
      int.tryParse(val[val.length - 1]) == null) {
    return 'invalid';
  }
  final delimiterPattern = RegExp(delimiters.map(RegExp.escape).join('|'));
  print(delimiterPattern.pattern);
  List<dynamic> vals = '2,,2,3'.split(',');
  print(vals);
  final parts = val.split(delimiterPattern);
  int finalVal = 0;
  for (int i = 0; i < parts.length; i++) {
    final part = parts[i];
    if (part.isEmpty || int.tryParse(part) == null) {
      return 'invalid';
    }
    finalVal += int.tryParse(part) ?? 0;
  }
  return finalVal;
}
