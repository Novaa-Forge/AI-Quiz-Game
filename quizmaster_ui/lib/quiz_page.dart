import 'package:flutter/material.dart';
import 'package:quizmaster_ui/MyTheme.dart';
import 'package:quizmaster_ui/question.dart';
import 'package:quizmaster_ui/question_controller.dart';

import 'answer.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController topicController = TextEditingController();

  // Highlights if there are questions to populate the UI
  bool questionsLoaded = false;
  // Used as a flag to show the circular loading indicator
  bool showLoading = false;
  // List of questions that will populate the UI
  List<Question> questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(gradient: MyTheme.backgroundGradient),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              "AI Quiz Master",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontFamily: "Saira",
                  color: MyTheme.secondaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2),
            ),
            const SizedBox(height: 50),
            Text(
              "What topic would you like questions for?",
              style: MyTheme.normalTextStyle,
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: 400,
                child: TextFormField(
                  style: MyTheme.normalTextStyle,
                  controller: topicController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.question_mark,
                      color: MyTheme.secondaryColor,
                    ),
                    hintText: 'Enter topic',
                    hintStyle: MyTheme.normalTextStyle
                        .copyWith(fontSize: 12, shadows: []),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Adjust the radius as needed
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                    questionsLoaded = false;
                  });

                  questions = await QuestionController.submitTopic(
                      topicController.text);
                  setState(() {
                    questionsLoaded = true;
                    showLoading = false;
                  });
                },
                child: Text(
                  "Generate",
                  style: MyTheme.normalTextStyle
                      .copyWith(color: MyTheme.primaryColor, shadows: []),
                )),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: Stack(
                children: [
                  questionsLoaded
                      ? QuestionsPanel(
                          questions: questions,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Generated questions will appear here",
                                style: MyTheme.normalTextStyle,
                              ),
                              const SizedBox(height: 10),
                              Icon(
                                Icons.list_alt,
                                size: 30,
                                color: MyTheme.secondaryColor,
                              )
                            ],
                          ),
                        ),
                  Visibility(
                    visible: showLoading,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.6),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class QuestionsPanel extends StatefulWidget {
  QuestionsPanel({super.key, required this.questions});

  final List<Question> questions;

  @override
  State<QuestionsPanel> createState() => _QuestionsPanelState();
}

class _QuestionsPanelState extends State<QuestionsPanel> {
  int currentQuestion = 0;
  int score = 0;
  bool showCompleteScreen = false;
  int selectedAnswer = -1;

  LinearGradient backgroundGradient = LinearGradient(colors: [
    MyTheme.tertiaryColor.withOpacity(0.3),
    MyTheme.tertiaryColor.withOpacity(0.6)
  ], begin: Alignment.centerLeft, end: Alignment.centerRight);

  LinearGradient selectedGradient = LinearGradient(colors: [
    MyTheme.tertiaryColor.withOpacity(0.3),
    MyTheme.tertiaryColor.withOpacity(0.6)
  ], begin: Alignment.centerLeft, end: Alignment.centerRight);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(height: 20),
        Visibility(
          visible: !showCompleteScreen,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                      width: 1060,
                      height: 30,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        value: (currentQuestion + 1) / widget.questions.length,
                        color: MyTheme.tertiaryColor,
                        backgroundColor:
                            MyTheme.secondaryColor.withOpacity(0.8),
                      )),
                  Center(
                    child: Text(
                      "${currentQuestion + 1}/${widget.questions.length}",
                      style:
                          MyTheme.normalTextStyle.copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                      margin: const EdgeInsets.all(20),
                      width: 1060,
                      height: 75,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyTheme.secondaryColor),
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                MyTheme.secondaryColor.withOpacity(0.3),
                                MyTheme.secondaryColor.withOpacity(0.6)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          boxShadow: [
                            BoxShadow(
                                color: MyTheme.secondaryColor.withOpacity(0.1),
                                offset: const Offset(5, 5),
                                blurRadius: 6,
                                spreadRadius: 3)
                          ]),
                      child: Center(
                          child: Text(
                        widget.questions[currentQuestion].question,
                        style: MyTheme.normalTextStyle
                            .copyWith(color: Colors.white),
                      ))),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "${currentQuestion + 1}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              color: Colors.white,
                              fontFamily: "Saira",
                              fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              Wrap(
                children: widget.questions[currentQuestion].answers
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  Answer answer = entry.value;
                  return TextButton(
                    onPressed: () async {
                      selectedAnswer = index;
                      await Future.delayed(const Duration(milliseconds: 250));
                      if (answer.correct) {
                        setState(() {
                          selectedGradient = LinearGradient(colors: [
                            Colors.green.withOpacity(0.6),
                            Colors.green.withOpacity(0.9)
                          ]);
                        });
                        score++;
                      } else {
                        setState(() {
                          selectedGradient = LinearGradient(colors: [
                            Colors.red.withOpacity(0.6),
                            Colors.red.withOpacity(0.9)
                          ]);
                        });
                      }
                      await Future.delayed(const Duration(milliseconds: 500));
                      setState(() {
                        selectedAnswer = -1;
                        if (currentQuestion >= widget.questions.length - 1) {
                          showCompleteScreen = true;
                        } else {
                          currentQuestion++;
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          width: 500,
                          height: 50,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: MyTheme.tertiaryColor),
                              borderRadius: BorderRadius.circular(10),
                              gradient: selectedAnswer == index
                                  ? selectedGradient
                                  : backgroundGradient,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.purple.withOpacity(0.1),
                                    offset: const Offset(5, 5),
                                    blurRadius: 6,
                                    spreadRadius: 3)
                              ]),
                          child: Center(
                              child: Text(
                            answer.answer,
                            style: MyTheme.normalTextStyle
                                .copyWith(color: Colors.white),
                          )),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            getAnswerLetter(index),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontFamily: "Saira",
                                    fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
        // TODO CLEAN UP COMPLETE SCREEN
        Visibility(
            visible: showCompleteScreen,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You scored:",
                    style: MyTheme.normalTextStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    "$score/${widget.questions.length}",
                    style: MyTheme.normalTextStyle.copyWith(fontSize: 40),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          score = 0;
                          currentQuestion = 0;
                          showCompleteScreen = false;
                        });
                      },
                      child: Text(
                        "Play again",
                        style: MyTheme.normalTextStyle
                            .copyWith(color: MyTheme.primaryColor),
                      ))
                ],
              ),
            ))
      ],
    );
  }

  String getAnswerLetter(int index) {
    String alphabet = "ABCDEFGHIJTKLMNOPQRSTUVWXYZ";
    return alphabet[index];
  }
}
