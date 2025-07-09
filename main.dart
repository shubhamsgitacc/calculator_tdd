import 'package:test/test.dart';

void main() {
  test('add num', () {
    expect(calculateString(''), 0);
    expect(calculateString('1'), 1);
    expect(calculateString('1,5'), 6);
    expect(calculateString("1,\n2,3"), 'invalid');
    expect(calculateString("1\n2,3"), 6);
    expect(calculateString("1,\n2,3"), 'invalid');
  });
}

///okay since added new line but need to add one more condition after reading the tdd kata 1 , one condition was missing
/// when input is "1,\n" not okay or may be "/n,1" its also not ok

calculateString(dynamic val) {
  //"1,\n,2,3"
  String intput = '$val';
  int finalVal = 0;
  try {
    for (int i = 0; i < intput.length; i++) {
      if ((i != 0 && i != intput.length - 1) && intput[i] == '\n') {
        if (intput[i - 1] == ',' || intput[i + 1] == ',') {
          return 'invalid';
        }
      }
      int num = int.tryParse(intput[i]) ?? 0;
      finalVal += num;
    }
  } catch (e) {
    print('Error while calucaltin the values $e');
  }
  return finalVal;
}
