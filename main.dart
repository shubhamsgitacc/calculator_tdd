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
    expect(calculateString('1,2,-3'), 'negatives not allowed');
    expect(calculateString('1,2,-3,-4,0'), 'multiple negatives found -3, -4');
    expect(calculateString('1000,1,2'), 3);
    expect(calculateString('999,1,2,1000'), 1002);

  });
}

///now let's fix for number that greater than 1000
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
          } else {
            return 'invalid';
          }
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
  if (val.isEmpty) return 'invalid';
  int negativeCount = 0;
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
  final parts = val.split(delimiterPattern);
  int finalVal = 0;
  List<int> negatives = [];
  for (int i = 0; i < parts.length; i++) {
    final part = parts[i];
    if (part.isEmpty || int.tryParse(part) == null) {
      return 'invalid';
    }
    int val = int.tryParse(part) ?? 0;
    if (val < 0) {
      negativeCount += 1;
      negatives.add(val);
      val = 0;
    }else if(val>=1000){
      val = 0;
    }
    finalVal += val;
  }
  if (negativeCount == 1) {
    return 'negatives not allowed';
  } else if (negativeCount > 1) {
    String str = '$negatives';
    return 'multiple negatives found ${str.substring(1, str.length - 1)}';
  }
  return finalVal;
}
