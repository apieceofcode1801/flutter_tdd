import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(const Right(123)));
    });

    test(
        'should return an InvalidInputFailure when the string is not an integer',
        () async {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test(
        'should return an InvalidInputFailure when the string is an nagative integer',
        () async {
      // arrange
      const str = '-12';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
