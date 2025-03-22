// should probably rename this file to chatbot.dart, handle all the UI layout and dealing
// with the gemini API here

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getGeminiResponse(String apiKey, String userInput) async {
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "system_instruction":
        {
          "parts":
            { "text": "You are a helpful medical-oriented chatbot. You will help the user on issues related to physical and emotional health and well-being. Start conversations by asking about how the user's day went"}
        },
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
      print('Failed to get Gemini response: ${response.statusCode}, ${response.body}');
      return 'Error: Could not get response. Status code ${response.statusCode}\n ${response.body}';
    }
  } catch (e) {
    print('Error during Gemini API call: $e');
    return 'Error: Could not get response.';
  }
}
