import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:visvocabflutter/flutter_flow/flutter_flow_util.dart';
import '../../flashcard.dart';

class ReviewPage extends StatefulWidget {
  final Flashcard flashcard;

  ReviewPage({required this.flashcard});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FFLocalizations.of(context).getText('revpage1')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              widget.flashcard.image,
              width: 300.0,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('revpage2'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String answer = _controller.text.trim();
                if (answer.isNotEmpty) {
                  double grade = answer.toLowerCase() == widget.flashcard.label.toLowerCase() ? 5.0 : 1.0;
                  widget.flashcard.update(grade);
                  widget.flashcard.save();
                  Navigator.of(context).pop();
                }
              },
              child: Text(FFLocalizations.of(context).getText('revpage3')),
            ),
          ],
        ),
      ),
    );
  }
}
