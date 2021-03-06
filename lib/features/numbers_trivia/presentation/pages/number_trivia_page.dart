import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/widgets/loading_widget.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/widgets/message_display.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/widgets/trivia_controls.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/widgets/trivia_display.dart';
import 'package:numbers_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Number Trivia'),
        ),
        body: buildBody());
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                // Top half
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(
                        message: 'Start searching!',
                      );
                    } else if (state is Loading) {
                      return LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is Error) {
                      return MessageDisplay(
                        message: state.message,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(height: 20),
                // Bottom half
                TriviaControls()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
