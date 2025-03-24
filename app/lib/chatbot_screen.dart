import 'package:flutter/material.dart';
import 'api/chatbot_api_handler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'dart:convert'; // for JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // temp caching

bool isPresetprompt = false;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  final String _apiKey = 'AIzaSyBGkAvvrnNGbemJ_fHyaYOAOVxyb0u8rVQ'; // Replace with your actual API key
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
        final botResponse = await getGeminiResponse(_apiKey, userInput);
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
          title: const Text('Clear chat', style: TextStyle(fontFamily: 'Work Sans Medium', color: Colors.black)),
          content: const Text('Are you sure you want to clear the chat?', style: TextStyle(fontFamily: 'Work Sans'),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _clearMessages(); // Clear the messages
              },
              child: const Text('Clear'),
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
        title: const Text('Chatbot'),
        actions: [
          TextButton.icon(
            onPressed: _showClearChatConfirmationDialog,
            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
            label: const Text('Clear chat', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                              const SizedBox(
                                    height: 60, width: 500,
                                    child: Padding(padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                                          child: Text("Hi there 🤗",
                                                    style: TextStyle(fontFamily: 'Work Sans Black', color: Colors.black, fontSize: 38),
                                                    textAlign: TextAlign.center,
                          ),
                        )
                      ),
                              const SizedBox(
                                    height: 60, width: 500,
                                    child: Padding(padding: EdgeInsets.only(top: 5.0, bottom: 0.0, left: 25.0, right: 25.0),
                                          child: Text("Start the conversation by choosing any preset prompts below or send your own message.",
                                                    style: TextStyle(fontFamily: 'Work Sans', color: Colors.blueGrey, fontSize: 13),
                                                    textAlign: TextAlign.center,
                          ),
                        )
                      ),
                      _buildPresetButton(
                        title: 'Play',
                        subtitle: 'Stimulate your brain by playing some brain teasers',
                        icon: Icons.casino,
                        onPressed: () {
                        _sendMessage(message: 'Come up with 3 interactive puzzle games that can be played by the user via text sequentially. First, return the three games and ask which one the user wants to play. For each turn, Provide an option for the user to quit the game or to continue. The game should be simple and easy and entertain as well as stimulate the brain. The game should be turn-based and based on natural language. Remember, you are to play the game with the user.');
                        },
                      ),
                      _buildPresetButton(
                        title: 'Summary',
                        subtitle: "Analyze your personal data for insights and know what's up",
                        icon: Icons.verified_user,
                        onPressed: () {
                        _sendMessage(message: 'Can you help me?');
                        },
                      ),
                      _buildPresetButton(
                        title: 'Health tips',
                        subtitle: 'Recommend tips for mental and physical wellbeing',
                        icon: Icons.spa,
                        onPressed: () {
                           _sendMessage(message: 'Give some recommendations to the user on maintaining mental and physical health. e.g. Steps that the user can take, things they can integrate into their daily or weekly routine, etc.');
                        }                      
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    },
                  ),
          ),
          TypingIndicator(isTyping: _isBotTyping),
          _buildTextComposer(),
        ],
      ),
    )
    );
  }

  Widget _buildTextComposer() {
    return SafeArea(
      bottom: true,
      minimum: EdgeInsets.only(bottom: 18.0, left: 12.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => _sendMessage(),
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
      const SnackBar(
        content: Text('Copied to Clipboard!'),
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
