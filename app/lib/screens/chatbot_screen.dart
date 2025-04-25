import 'package:flutter/material.dart';
import '/services/chatbot_api_handler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'dart:convert'; // for JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // temp caching
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool isPresetprompt = false;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}


class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  final String _apiKey = dotenv.env["GEMINI_API_KEY"]!;
  bool _isBotTyping = false;
  static const String _messagesKey = 'chatbot_messages'; // Key for saving messages

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Load messages from cache when the widget initializes.
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList(_messagesKey);
    if (messagesJson != null) {
      setState(() {
        _messages = messagesJson
            .map((json) => ChatMessage.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson =
        _messages.map((message) => jsonEncode(message.toJson())).toList();
    await prefs.setStringList(_messagesKey, messagesJson);
  }

  void _sendMessage({String? message}) async {
    final userInput = message ?? _controller.text;
    if (userInput.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: userInput, isMe: true));
        _controller.clear();
        _isBotTyping = true;
      });
      _saveMessages(); // Save messages after adding a new one.

      try {
        // Create a structured conversation history
        List<Map<String, dynamic>> conversationHistory = _messages.map((msg) => {
              "role": msg.isMe ? "user" : "assistant",
              "parts": [{"text" : msg.text}]
            }).toList();

        final botResponse = await getGeminiResponse(_apiKey, {'contents' : conversationHistory});
        
        setState(() {
          _messages.add(ChatMessage(text: botResponse, isMe: false));
          _isBotTyping = false;
        });
        _saveMessages(); // Save messages after adding bot response.
      } catch (e) {
        setState(() {
          _messages.add(ChatMessage(text: 'Error: $e', isMe: false));
          _isBotTyping = false;
        });
        _saveMessages(); // Save messages after error
      }
    }
  }


  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
    _saveMessages(); // Save the empty message list
  }

  void _showClearChatConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.chatbotClearChatMessage, style: TextStyle(fontFamily: 'Work Sans Medium', color: Colors.black)),
          content: Text(AppLocalizations.of(context)!.chatbotClearChatConfirmation, style: TextStyle(fontFamily: 'Work Sans'),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.buttonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _clearMessages(); // Clear the messages
              },
              child: Text(AppLocalizations.of(context)!.buttonClear),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: null, // const Text('Chatbot'),
        actions: [
          TextButton.icon(
            onPressed: _showClearChatConfirmationDialog,
            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
            label: Text(AppLocalizations.of(context)!.chatbotClearChatButton, style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      ),
      body: Column(
      children: [
        Expanded(
          child:
          // Expanded( child:
          _messages.isEmpty
                ? Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                              SizedBox(height: 90-30,),
                              SizedBox(
                                    height: 60, width: 500,
                                    child: Padding(padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                                          child: Text(AppLocalizations.of(context)!.chatbotTitle,
                                                    style: TextStyle(fontFamily: 'Work Sans Black', color: Colors.black, fontSize: 38),
                                                    textAlign: TextAlign.center,
                          ),
                        )
                      ),
                              SizedBox(
                                    height: 60, width: 500,
                                    child: Padding(padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                                          child: Text(AppLocalizations.of(context)!.chatbotSubtitle,
                                                    style: TextStyle(fontFamily: 'Work Sans', color: Colors.blueGrey, fontSize: 13),
                                                    textAlign: TextAlign.center,
                          ),
                        )
                      ),
                      _buildPresetButton(
                        title: AppLocalizations.of(context)!.chatbotPresetTitle1,
                        subtitle: AppLocalizations.of(context)!.chatbotPresetSubitle1,
                        icon: Icons.casino,
                        onPressed: () {
                        _sendMessage(message: AppLocalizations.of(context)!.chatbotPresetMessage1);
                        },
                      ),
                      _buildPresetButton(
                        title: AppLocalizations.of(context)!.chatbotPresetTitle2,
                        subtitle: AppLocalizations.of(context)!.chatbotPresetSubitle2,
                        icon: Icons.verified_user,
                        onPressed: () {
                        _sendMessage(message: AppLocalizations.of(context)!.chatbotPresetMessage2);
                        },
                      ),
                      _buildPresetButton(
                        title: AppLocalizations.of(context)!.chatbotPresetTitle3,
                        subtitle: AppLocalizations.of(context)!.chatbotPresetSubitle3,
                        icon: Icons.spa,
                        onPressed: () {
                           _sendMessage(message: AppLocalizations.of(context)!.chatbotPresetMessage3);
                        }                      
                      ),
                      SizedBox(height: 130,),
                    ],
                  )
        )
                : ListView.builder(
                    shrinkWrap: true, // flutter will crash if this isnt added
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    },
                  ),
          ),
        TypingIndicator(isTyping: _isBotTyping),
          Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: _buildTextComposer(),
          )
          ),
      ],
    ),
  );
}

  Widget _buildTextComposer() {
    return SafeArea(
      bottom: true,
      minimum: EdgeInsets.zero,
      child: Container(
        margin: null, // const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white, // White background color
          borderRadius: null,
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => _sendMessage(),
                decoration:
                    InputDecoration.collapsed(hintText: AppLocalizations.of(context)!.chatbotHintText),
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _sendMessage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SafeArea(
      child: Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 32),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(fontSize: 14)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
        ),
      ),
    )
    );
  }
}




// Widget for messages in chat
class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.isMe});
  final String text;
  final bool isMe;

  // Add these methods for JSON serialization
  ChatMessage.fromJson(Map<String, dynamic> json, {super.key})
      : text = json['text'],
        isMe = json['isMe'];

  Map<String, dynamic> toJson() => {
        'text': text,
        'isMe': isMe,
      };

Future<void> _copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));

  if (context.mounted) { // Check if the context is still valid
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.chatbotCopiedToClipboard),
        duration: Duration(milliseconds: 750),
      ),
    );
  } else {
    // Optionally, handle the case where the context is not mounted
    print('Context is not mounted. SnackBar not shown.');
  }
}

  @override
  Widget build(BuildContext context) {
    return Container( // Main container
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Container( // Bot avatar container
              margin: const EdgeInsets.only(right: 16.0),
              child: const CircleAvatar(child: Icon(Icons.smart_toy, size: 24, color: Color.fromARGB(255, 197, 146, 94))),
            ),
            Flexible( // Bot and user message container
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isMe ? const Color.fromARGB(255, 21, 92, 150) : const Color.fromARGB(255, 248, 219, 185),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MarkdownBody( // Use MarkdownBody instead of Text
                        data: text, // Your message text (which can contain Markdown)
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).
                                    copyWith(
                                    p: TextStyle(color: isMe ? Colors.white : Colors.black), // Style for paragraphs
                    ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              iconSize: 20, // Adjust icon size as needed
              onPressed: () => _copyToClipboard(context, text), // Copy text on press
            ),
          if (isMe)
            Container( // User avatar container
              margin: const EdgeInsets.only(left: 16.0),
              child: const CircleAvatar(child: Text('Me')),
            ),
            ],
      ),
    );
  }
}


// Typing indicator animation while waiting for response from Gemini
class TypingIndicator extends StatelessWidget {
  final bool isTyping;

  const TypingIndicator({super.key, required this.isTyping});

  @override
  Widget build(BuildContext context) {
    if (!isTyping) {
      return const SizedBox.shrink();
    }

    return LoadingAnimationWidget.horizontalRotatingDots(
      color: const Color.fromARGB(255, 21, 92, 150), // Adjust color as needed
      size: 50, // Adjust size as needed
    );
  }
}
