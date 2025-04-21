// should probably rename this file to chatbot.dart, handle all the UI layout and dealing
// with the gemini API here

import 'dart:convert';
import 'package:http/http.dart' as http;


Future<String> getGeminiResponse(String apiKey, dynamic userInput) async {
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      // body: jsonEncode({
      //   'contents': [
      //     {
      //       'parts': [
      //         {'text': userInput}
      //       ]
      //     }
      //   ],
      // }),
      body: jsonEncode(userInput)

    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final generatedText = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
      return generatedText;
    } else {
      return 'Error: Could not get response. Status code ${response.statusCode}\n ${response.body}';
    }
  } catch (e) {
    return 'Error: Could not get response. ${e}';
  }
}

Future<String> getGeminiResponseQuick(String apiKey, String userInput) async {
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': userInput}
            ]
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final generatedText = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
      return generatedText;
    } else {
      return 'Error: Could not get response. Status code ${response.statusCode}\n ${response.body}';
    }
  } catch (e) {
    return 'Error: Could not get response. ${e}';
  }
}