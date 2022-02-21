import 'package:flutter/material.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/core/util/input_converter.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/controller/number_trivia_state.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage = 'Invalid Input';

class NumberTriviaController extends GetxController {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaState _state = Empty();
  NumberTriviaState get state => _state;
  final _textController = TextEditingController();
  TextEditingController get textController => _textController;
  String inputStr = '';

  NumberTriviaController(
      {required GetConcreteNumberTrivia concrete,
      required GetRandomNumberTrivia random,
      required this.inputConverter})
      : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  setState(NumberTriviaState state) {
    _state = state;
    update();
  }

  void loadNumber() {
    // Clearing the TextField to prepare it for the next inputted number
    textController.clear();
    final result = inputConverter.stringToUnsignedInteger(inputStr);
    result.fold(
        (failure) => setState(const Error(message: invalidInputFailureMessage)),
        (number) async {
      setState(Loading());
      final result = await getConcreteNumberTrivia(Params(number));
      result.fold(
          (failure) => setState(const Error(message: serverFailureMessage)),
          (numberTrivia) => setState(Loaded(trivia: numberTrivia)));
    });
  }

  void loadRandom() async {
    textController.clear();
    setState(Loading());
    final result = await getRandomNumberTrivia(NoParams());
    result.fold(
        (failure) => setState(const Error(message: serverFailureMessage)),
        (numberTrivia) => setState(Loaded(trivia: numberTrivia)));
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
