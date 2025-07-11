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
    expect(calculateString('//[@@][##]\n1@@2##3'), 6);
    expect(calculateString('//[[][##]\n1[2##3'), 6);
    expect(
        calculateString(
          '//***\n999***1***2***1000',
        ),
        1002);
    expect(
        calculateString(
          '//####\n999####1',
        ),
        1000);
  });
}

///since we handled every condition now lets optimize code
calculateString(dynamic val) {
  try {
    String input = '$val';
    bool customDelimiter = false;
    if (input.isEmpty) return 0;
    if (input.length == 1) {
      int? val = int.tryParse(input[0]);
      return val ?? 'invalid';
    } else if (input.length == 2) {
      int? first = int.tryParse(input[0]);
      int? second = int.tryParse(input[1]);
      if (first != null && second != null) {
        return int.parse('$first$second');
      }
    }
    if (input.startsWith('//')) {
      customDelimiter = true;
    }
    if (customDelimiter) {
      String delimiter = '';
      List<String> deliList = [];
      String val = '';
      bool isDeliList = false;
      for (int i = 2; i < input.length; i++) {
        if (input[i] != '\n') {
          if (input[i] == '[') {
            isDeliList = true;
          }
          if (isDeliList) {
            delimiter += input[i];
            if (input[i] == ']') {
              deliList.add(delimiter.substring(1, delimiter.length - 1));
              delimiter = '';
            }
          } else {
            delimiter += input[i];
          }
        } else {
          if (i != input.length) {
            val = input.substring(i + 1, input.length);
          } else {
            return 0;
          }
          break;
        }
      }
      return calc(val, customDelimiter: isDeliList ? deliList : [delimiter]);
    } else {
      return calc(input);
    }
  } catch (e) {
    print('Error while calculating the values $e');
    return 'error';
  }
  // return finalVal;
}

dynamic calc(String val, {List<String>? customDelimiter}) {
  if (val.isEmpty) return 'invalid';
  int negativeCount = 0;

  // final delimiters = [',', '\n',"@@"];
  List<String> delimiters =
      (customDelimiter ?? []).isNotEmpty && customDelimiter != null
          ? customDelimiter
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
    } else if (val >= 1000) {
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
