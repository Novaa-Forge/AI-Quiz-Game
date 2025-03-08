class Answer {
  int number;
  String answer;
  bool correct;

  Answer({required this.number, required this.answer, required this.correct});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
        number: json['number'],
        answer: json['answer'],
        correct: json['correct']);
  }
}
