import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel(String text, int number) : super(text, number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(json['text'], (json['number'] as num).toInt());
  }

  Map<String, dynamic> toJson() => {'text': text, 'number': number};
}
