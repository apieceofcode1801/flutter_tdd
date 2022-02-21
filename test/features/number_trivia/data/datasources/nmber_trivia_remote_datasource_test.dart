import 'dart:convert';

import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fix_reader.dart';
import 'nmber_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  setupMockupHttpClientFailure400() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 400));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    // TODO: resolve this test
    test('''should perform a GET request on a URL with number being the endpoint
        and with application/json header''', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      final uri = Uri.http('numbersapi.com', '/2');
      verify(mockHttpClient
          .get(uri, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTriviaModel when the response code is 200',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when the response code is not 200',
        () async {
      // arrange
      setupMockupHttpClientFailure400();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getNumberNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    // TODO: resolve this test
    // test('''should perform a GET request on a URL with number being the endpoint
    //     and with application/json header''', () async {
    //   // arrange
    //   when(mockHttpClient.get(any, headers: anyNamed('headers')))
    //       .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
    //   // act
    //   dataSource.getRandomNumberTrivia();
    //   // assert
    //   final uri = Uri.http('numbersapi.com', '/random');
    //   verify(() => mockHttpClient
    //       .get(uri, headers: {'Content-Type': 'application/json'})).called(1);
    // });

    test('should return NumberTriviaModel when the response code is 200',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when the response code is not 200',
        () async {
      // arrange
      setupMockupHttpClientFailure400();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
