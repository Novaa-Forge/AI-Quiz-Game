import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quizmaster_ui/question.dart';

/// Handles calls to the question API service
class QuestionController {
  /// Calls the API endpoint with the [topic] that is sent
  static Future<List<Question>> submitTopic(String topic) async {
    /// Endpoint of the service running
    const url = 'http://localhost:10000/submit_topic';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'topic': topic});
    List<Question> toReturn = [];

    /// demo string for UI development
    /// Use so you don't have to wait for the API to respond
    String demoResponse =
        """{"questions":[{"number":1,"question":"What is the primary function of a car's engine?","answer":[{"number":1,"answer":"To generate power for the vehicle","correct":true},{"number":2,"answer":"To transmit power to the wheels","correct":false},{"number":3,"answer":"To cool the air inside the engine","correct":false},{"number":4,"answer":"To store energy for later use","correct":true},{"number":2,"answer":":[{","correct":false}]},{"number":1,"question":"What is the primary function of a car's transmission?","answer":[{"number":3,"answer":"To transmit power from the engine to the wheels","correct":true},{"number":4,"answer":"To cool the air inside the engine","correct":false},{"number":1,"answer":"To store energy for later use","correct":false}]},{"number":2,"question":"What is the primary function of a car's exhaust system?","answer":[{"number":3,"answer":"To remove harmful gases from the vehicle","correct":true},{"number":1,"answer":"To transmit power to the wheels","correct":false}]},{"number":2,"question":"What is a car's primary mode of transportation?","answer":[{"number":3,"answer":"To move on roads and highways","correct":true},{"number":1,"answer":"To generate power for the vehicle","correct":false}]},{"number":2,"question":"What is a car's primary source of energy?","answer":[{"number":3,"answer":"Internal combustion","correct":true},{"number":1,"answer":"Solar power","correct":false}]},{"number":2,"question":"What is the main function of a car's brakes?","answer":[{"number":3,"answer":"To slow down the vehicle","correct":true},{"number":1,"answer":"To generate power for the wheels","correct":false}]},{"number":2,"question":"What is a car's primary feature?","answer":[{"number":3,"answer":"Windows","correct":true},{"number":1,"answer":"To generate power for the vehicle","correct":false}]},{"number":2,"question":"What is a car's primary mode of transportation?","answer":[{"number":3,"answer":"Roads and highways","correct":true},{"number":1,"answer":"To generate power for the vehicle","correct":false}]},{"number":2,"question":"What is a car's primary source of energy?","answer":[{"number":3,"answer":"Electrical power","correct":true},{"number":1,"answer":"Internal combustion","correct":false}]},{"number":2,"question":"What is the main function of a car's suspension?","answer":[{"number":3,"answer":"To absorb shocks and vibrations","correct":true},{"number":1,"answer":"To generate power for the vehicle","correct":false}]}]}""";

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    // if response is error free (200)
    if (response.statusCode == 200) {
      print('Response received successfully!');
      Map<String, dynamic> bodyAsJson = jsonDecode(response.body);
      for (Map<String, dynamic> questionAsJson in bodyAsJson['questions']) {
        toReturn.add(Question.fromJson(questionAsJson));
      }
      return toReturn;
    } else {
      print('Failed to post question: ${response.statusCode}');
      return toReturn;
    }

    /// Uncomment below for demo response
    /// Emulates the API call
    // await Future.delayed(const Duration(milliseconds: 500));
    // Map<String, dynamic> bodyAsJson = jsonDecode(demoResponse);
    // for (Map<String, dynamic> questionAsJson in bodyAsJson['questions']) {
    //   toReturn.add(Question.fromJson(questionAsJson));
    // }
    //
    // return toReturn;
  }
}
