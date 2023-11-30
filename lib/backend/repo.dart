import 'dart:convert';


import 'package:http/http.dart' as http;

import '../Model/gptresponse.dart';


abstract class HomePageRepository {
  Future<dynamic> askAI(String promptt);
}

class HomePageRepo extends HomePageRepository {
  @override
  Future<dynamic> askAI(String promptt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.pawan.krd/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer pk-hPWheLEdNNjBwmDyWfrvFIDRNkbdbLlpdWcaLsvCdhFzhJHS'
        },
        body: jsonEncode(
          {
            "model": "pai-001-light-beta",
            "prompt": "Create a recipe from a list of ingredients: \n$promptt.",
            "max_tokens": 800,
            "temperature": 0,
            "top_p": 1,
          },
        ),
      );
      print(response.body);
      return ResponseModel.fromJson(response.body).choices[0]['text'];
    } catch (e) {
      return e.toString();
    }
  }
}