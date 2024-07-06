import 'package:saiflash/widgets/answer.dart';

class Question {
  Question(
      {required this.questionText,
      required this.answers,
      required this.correctAnswer,
      required this.id});

  final String id;
  final String questionText;
  final List<Answer> answers;
  final String correctAnswer;
  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'answers': answers.map((answer) => answer.toMap()).toList(),
      'correctAnswer': correctAnswer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map, String id) {
    return Question(
      id: id,
      questionText: map['questionText'],
      answers: List<Answer>.from(
          map['answers']?.map((answerMap) => Answer.fromMap(answerMap))),
      correctAnswer: map['correctAnswer'],
    );
  }
}
