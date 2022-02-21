import 'dart:convert';

import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fix_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel('Test', 1);
  final tNumberTriviaDoubleModel = NumberTriviaModel('Test', 1e40.toInt());

  test('should be a subclass of NumberTrivia entity', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson ', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when the JSON number is a double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaDoubleModel);
    });
  });

  test('should return a JSON map containing the proper data', () async {
    // act
    final result = tNumberTriviaModel.toJson();
    // assert
    expect(result, {'text': 'Test', 'number': 1});
  });
}
