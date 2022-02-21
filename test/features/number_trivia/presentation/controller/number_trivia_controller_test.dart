// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/core/util/input_converter.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/controller/number_trivia_controller.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/controller/number_trivia_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_controller_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaController controller;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    controller = NumberTriviaController(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be [Empty]', () async {
    // arrange
    // act
    // assert
    expect(controller.state, equals(Empty()));
  });

  group('get concrete number trivia', () {
    const tNumberString = '123';
    const tNumberParsed = 123;
    const tNumberTrivia = NumberTrivia('text', tNumberParsed);
    setUp(() {
      controller.inputStr = tNumberString;
    });
    setupGetConcreteNumberTriviaSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenAnswer((_) => Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    setupGetConcreteNumberTriviaFail() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenAnswer((_) => Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
    }

    test(
        'should call stringToUnsignedInteger with controller.inputStr when entering the number string',
        () async {
      // arrange
      setupGetConcreteNumberTriviaSuccess();
      // act
      controller.loadNumber();
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(controller.inputStr));
    });

    test('should update state Error when entering an invalid unsigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenAnswer((_) => Left(InvalidInputFailure()));
      // act
      controller.loadNumber();
      // assert
      expect(
          controller.state, equals(Error(message: invalidInputFailureMessage)));
    });

    test(
        'should call GetConcreteNumberTrivia use case when entering an unsigned integer',
        () async {
      // arrange
      setupGetConcreteNumberTriviaSuccess();
      // act
      controller.loadNumber();
      await untilCalled(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
    });

    test(
        'should update states [Loading, Loaded] when get the concrete trivia number successfully',
        () async {
      // arrange
      setupGetConcreteNumberTriviaSuccess();
      // act
      controller.loadNumber();
      // assert
      expect(controller.state, equals(Loading()));
      await untilCalled(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
      expect(controller.state, equals(Loaded(trivia: tNumberTrivia)));
    });
    test(
        'should update states [Loading, Error] when get the concrete trivia number failed',
        () async {
      // arrange
      setupGetConcreteNumberTriviaFail();
      // act
      controller.loadNumber();
      // assert
      expect(controller.state, equals(Loading()));
      await untilCalled(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
      expect(controller.state, equals(Error(message: serverFailureMessage)));
    });
  });

  group('get random number trivia', () {
    const tNumberTrivia = NumberTrivia('text', 123);
    setUp(() {});
    setupGetRandomNumberTriviaSuccess() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    setupGetRandomNumberTriviaFail() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
    }

    test(
        'should call GetRandomNumberTrivia use case when entering an unsigned integer',
        () async {
      // arrange
      setupGetRandomNumberTriviaSuccess();
      // act
      controller.loadRandom();
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'should update states [Loading, Loaded] when get the random trivia number successfully',
        () async {
      // arrange
      setupGetRandomNumberTriviaSuccess();
      // act
      controller.loadRandom();
      // assert
      expect(controller.state, equals(Loading()));
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));
      expect(controller.state, equals(Loaded(trivia: tNumberTrivia)));
    });
    test(
        'should update states [Loading, Error] when get the concrete trivia number failed',
        () async {
      // arrange
      setupGetRandomNumberTriviaFail();
      // act
      controller.loadRandom();
      // assert
      expect(controller.state, equals(Loading()));
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));
      expect(controller.state, equals(Error(message: serverFailureMessage)));
    });
  });
}
