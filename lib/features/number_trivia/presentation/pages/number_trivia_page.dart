import 'package:flutter/material.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/controller/number_trivia_controller.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/controller/number_trivia_state.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_tdd/injection_container.dart';
import 'package:get/get.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
          child: GetBuilder<NumberTriviaController>(
        init: getIt<NumberTriviaController>(),
        builder: (controller) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  _topHalf(controller),
                  const SizedBox(height: 20),
                  _triviaControls(context, controller),
                  // Bottom half
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _topHalf(NumberTriviaController controller) {
    final state = controller.state;
    if (state is Empty) {
      return const MessageDisplay(message: 'Start searching');
    } else if (state is Error) {
      return MessageDisplay(message: state.message);
    } else if (state is Loading) {
      return const LoadingWidget();
    } else if (state is Loaded) {
      return TriviaDisplay(numberTrivia: state.trivia);
    }
    return Container();
  }

  Widget _triviaControls(
      BuildContext context, NumberTriviaController controller) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller.textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            controller.inputStr = value;
          },
          onSubmitted: (_) {
            controller.loadNumber();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                  child: const Text('Search'),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: controller.loadNumber),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: controller.loadRandom,
              ),
            ),
          ],
        )
      ],
    );
  }
}
