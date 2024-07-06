import 'package:flutter/material.dart';
import 'package:saiflash/models/question.dart';

import 'answer.dart';

var _selectedIndex = -1;

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key, required this.question});

  final Question question;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.question.questionText,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontSize: 32),
        ),
        const SizedBox(height: 16),
        ...widget.question.answers.map((answer) {
          return Answer(
            answer: answer.answer,
            symbol: answer.symbol,
            selected: _selectedIndex == widget.question.answers.indexOf(answer),
            onSelected: () {
              setState(() {
                _selectedIndex = widget.question.answers.indexOf(answer);
              });
            },
          );
        }),
      ],
    );
  }
}

bool isAnswerCorrect(Question question) {
  var temp = _selectedIndex;
  if (_selectedIndex > -1) _selectedIndex = -1;
  if (temp != -1) {
    return question.correctAnswer == question.answers[temp].answer.toString();
  }
  return false;
}

void resetSelectedIndex() {
  _selectedIndex = -1;
}
