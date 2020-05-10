import 'package:clean_arch/features/number_trivia/number_trivia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrviaControl extends StatefulWidget {
  const TrviaControl({
    Key key,
  }) : super(key: key);

  @override
  _TrviaControlState createState() => _TrviaControlState();
}

class _TrviaControlState extends State<TrviaControl> {
  final _controller = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a positive number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) => dispatchConconcrete(),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConconcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConconcrete() {
    _controller.clear();
    if (inputStr == null)
      return BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForRandomNumber());
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)..add(GetTriviaForRandomNumber());
  }
}
