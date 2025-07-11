# calculator_tdd
This project is a simple String Calculator built using the Test-Driven Development (TDD) approach in Dart. It parses a string input with various delimiter formats and returns the sum of the numbers inside.


to run open folder and on terminal hit command dart main.dart

as our code by default only supports ',' and '\n' delimiters , and around them only number are allowed

to run test use -  expect(calculateString('1,2'), 3); here '1,2' are inputs and 3 are output or expected,  should be in integer or double only not '3', for invalid is only 'invalid'  or custom message for negatives;

to pass custom delimiters use expect(calculateString('//@\n11@23'), 34);

and since also supporting floats no delimiters that contains '.' is allowed

for invalid cases - expect(calculateString('1,'), 'invalid');