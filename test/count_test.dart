import 'package:flutter_test/flutter_test.dart';
import 'package:monstar/count.dart';

void main() {
  group('Counter class -', () {
    final PlusNumber plusNumber = PlusNumber();

    test('give count class when it is instanciated then it is equal 0', () {
      final val = plusNumber.number;

      expect(val, 10);
    });

    test('give increase func when it is instantiated then it is equal 11', () {
      final val = plusNumber.plusNum();

      expect(val, 11);
    });

    test('give Decrease func when it is instantiated then it is equal 9', () {
      final val = plusNumber.descreaseNum();

      expect(val, 10);
    });
  });
}
