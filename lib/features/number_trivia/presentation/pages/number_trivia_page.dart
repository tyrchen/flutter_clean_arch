import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:clean_arch/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (BuildContext context) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                // Top half
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return LoadingWidget();
                      }
                      if (state is Loaded)
                        return TriviaDisplay(trivia: state.trivia);
                      if (state is Empty)
                        return MessageDisplay(message: 'Start searching...');
                      if (state is Error)
                        return MessageDisplay(message: state.message);
                      return MessageDisplay(message: 'Unknown state $state');
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Bottom half
                TrviaControl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
