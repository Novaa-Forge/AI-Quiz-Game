import 'answer.dart';

class Question {
  int number;
  String question;
  List<Answer> answers;

  Question(
      {required this.number, required this.question, required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        number: json['number'],
        question: json['question'],
        answers: (json['answer'] as List<dynamic>).map((answer) {
          return Answer.fromJson(answer);
        }).toList());
  }
}
