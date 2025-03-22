import 'package:flutter/material.dart';
import 'chatbot_api_handler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart'; // For Clipboard


class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final String _apiKey = 'AIzaSyBGkAvvrnNGbemJ_fHyaYOAOVxyb0u8rVQ'; // Replace with your actual API key
  bool _isBotTyping = false; // Signal to enable/disable loading animation


  void _sendMessage() async {
    final userInput = _controller.text;
    if (userInput.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: userInput, isMe: true));
        _controller.clear();
        _isBotTyping = true; // Bot is typing right after user message sent
      });

      try {
        final botResponse = await getGeminiResponse(_apiKey, userInput);
        setState(() {
          _messages.add(ChatMessage(text: botResponse, isMe: false));
          _isBotTyping = false; // Bot not typing after bot message sent (received response from gemini)
        });
      } catch (e) {
        setState(() {
          _messages.add(ChatMessage(text: 'Error: $e', isMe: false));
          _isBotTyping = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Send a message to \nbegin the conversation 🤗',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
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
    );
  }

  Widget _buildTextComposer() {
    return SafeArea( // Wrap your Container with SafeArea
      bottom: true, // Ensure it applies to the bottom
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
  }

// Widget for messages in chat
class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.isMe});
  final String text;
  final bool isMe;


  // Define a global key to access the current context.
  static final navigatorKey = GlobalKey<NavigatorState>();

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(content: Text('Copied to Clipboard!'), duration: Duration(milliseconds: 750),),
    );
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
              child: const CircleAvatar(child: Text('Bot')),
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
              onPressed: () => _copyToClipboard(text), // Copy text on press
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
