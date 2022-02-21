// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/core/util/input_converter.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia('text', 1);

    setupGetConcreteNumberTriviaSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setupGetConcreteNumberTriviaSuccess();
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    // TODO
    // test('should emit [Error] when the input is invalid', () async {
    //   // arrange
    //   when(mockInputConverter.stringToUnsignedInteger(any))
    //       .thenReturn(Left(InvalidInputFailure()));
    //   // assert
    //   expectLater(
    //       bloc.state,
    //       emitsInOrder(
    //           [Empty(), const Error(message: invalidInputFailureMessage)]));
    //   // act
    //   bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    // });

    test('should get data from the concrete use case', () async {
      // arrange
      setupGetConcreteNumberTriviaSuccess();
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
    });

// TODO
    // test('should emit [Loading, Loaded] when data is gotten successfully',
    //     () async {
    //   // arrange
    //   setupGetConcreteNumberTriviaSuccess();
    //   // assert later
    //   final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
    //   expectLater(bloc.state, emitsInOrder(expected));
    //   // act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });
    // test('should emit [Loading, Error] when data is gotten failure', () async {
    //   // arrange
    //   when(mockInputConverter.stringToUnsignedInteger(any))
    //       .thenReturn(const Right(tNumberParsed));
    //   when(mockGetConcreteNumberTrivia(any))
    //       .thenAnswer((_) async => Left(ServerFailure()));
    //   // assert later
    //   final expected = [
    //     Empty(),
    //     Loading(),
    //     Error(message: serverFailureMessage)
    //   ];
    //   expectLater(bloc.state, emitsInOrder(expected));
    //   // act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });

    // test('''should emit [Loading, Error] with a proper
    // message for the error when getting data fails''', () async {
    //   // arrange
    //   when(mockInputConverter.stringToUnsignedInteger(any))
    //       .thenReturn(const Right(tNumberParsed));
    //   when(mockGetConcreteNumberTrivia(any))
    //       .thenAnswer((_) async => Left(CacheFailure()));
    //   // assert later
    //   final expected = [
    //     Empty(),
    //     Loading(),
    //     Error(message: cacheFailureMessage)
    //   ];
    //   expectLater(bloc.state, emitsInOrder(expected));
    //   // act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });
  });
  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia('text', 1);

    setupGetRandomNumberTriviaSuccess() {
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    // TODO
    // test('should emit [Error] when the input is invalid', () async {
    //   // arrange
    //   when(mockInputConverter.stringToUnsignedInteger(any))
    //       .thenReturn(Left(InvalidInputFailure()));
    //   // assert
    //   expectLater(
    //       bloc.state,
    //       emitsInOrder(
    //           [Empty(), const Error(message: invalidInputFailureMessage)]));
    //   // act
    //   bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    // });

    test('should get data from the concrete use case', () async {
      // arrange
      setupGetRandomNumberTriviaSuccess();
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

// TODO
    // test('should emit [Loading, Loaded] when data is gotten successfully',
    //     () async {
    //   // arrange
    //   setupGetRandomNumberTriviaSuccess();
    //   // assert later
    //   final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
    //   expectLater(bloc.state, emitsInOrder(expected));
    //   // act
    //   bloc.add(GetTriviaForRandomNumber());
    // });
    // test('should emit [Loading, Error] when data is gotten failure', () async {
    //   // arrange
    //   when(mockGetRandomNumberTrivia(any))
    //       .thenAnswer((_) async => Left(ServerFailure()));
    //   // assert later
    //   final expected = [
    //     Empty(),
    //     Loading(),
    //     Error(message: serverFailureMessage)
    //   ];
    //   expectLater(bloc.state, emitsInOrder(expected));
    //   // act
    //   bloc.add(GetTriviaForRandomNumber());
    // });

    // test('''should emit [Loading, Error] with a proper
    // message for the error when getting data fails''', () async {
    //   // arrange
    //   when(mockGetRandomNumberTrivia(any))
    //       .thenAnswer((_) async => Left(CacheFailure()));
    //   // assert later
    //   final expected = [
    //     Empty(),
    //     Loading(),
    //     Error(message: cacheFailureMessage)
    //   ];
    //   expectLater(bloc.state, emitsInOrder(expected));
    //   // act
    //   bloc.add(GetTriviaForRandomNumber());
    // });
  });
}
