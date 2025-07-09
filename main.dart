import 'package:test/test.dart';

void main() {
  test('add num', () {
    expect(calculateString(''), 0);
    expect(calculateString('1'), 1);
    expect(calculateString('1,5'), 6);
    expect(calculateString("1\n2,3"), 6);
  });
}

///for comma seperation and for new line im simply using tryint or can also use int.parse but using tryint which have trycatch by deault
///so the idea is to eliminate any character other than number first since for now requirement only is for remove commas and new lines
int calculateString(dynamic val) {
  String intput = '$val';
  int finalVal = 0;
  try {
    for (int i = 0; i < intput.length; i++) {
      int num = int.tryParse(intput[i]) ?? 0;
      finalVal += num;
    }
  } catch (e) {
    print('Error while calucaltin the values $e');
  }
  return finalVal;
}
