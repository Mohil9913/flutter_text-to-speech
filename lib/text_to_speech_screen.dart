import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'en-US';

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() async {
    // Get supported languages
    List<dynamic> languages = await _flutterTts.getLanguages;
    log("\n\n\nSupported Languages: $languages");

    // Set initial language
    await _flutterTts.setLanguage(_selectedLanguage);
  }

  void _speak() async {
    String text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Text Provided!')),
      );
      return;
    }

    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to Speech'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speak,
        child: Icon(Icons.play_arrow_sharp),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              textAlign: TextAlign.start,
              textDirection: _isArabic(_textController.text)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text to speak...',
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(value: 'en-US', child: Text('English (US)')),
                DropdownMenuItem(value: 'hi-IN', child: Text('Hindi')),
                DropdownMenuItem(value: 'gu-IN', child: Text('Gujarati')),
                DropdownMenuItem(value: 'ar-SA', child: Text('Arabic')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                  _flutterTts.setLanguage(_selectedLanguage);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
