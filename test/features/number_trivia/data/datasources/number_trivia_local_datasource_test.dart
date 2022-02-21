import 'dart:convert';

import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fix_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('local_trivia.json')));
    test(
        'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenAnswer((_) => fixture('local_trivia.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not one cached value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenAnswer((_) => null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel('Test', 1);
    test('should call SharePreferences to cache the data', () async {
      // arrange
      when(mockSharedPreferences.setString(cachedNumberTrivia, any))
          .thenAnswer((_) async => true);
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          cachedNumberTrivia, expectedJsonString));
    });
  });
}
