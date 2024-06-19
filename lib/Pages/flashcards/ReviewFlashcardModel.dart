import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../flashcard.dart';

class ReviewFlashcardModel with ChangeNotifier {
  late List<Flashcard> flashcardsToReview = [];

  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocusNode = FocusNode();

  ReviewFlashcardModel() {
    loadFlashcardsToReview();
  }

  Future<void> loadFlashcardsToReview() async {
    final List<Flashcard> allFlashcards = await HiveManager.getFlashcards();
    flashcardsToReview = allFlashcards.where((card) {
      return card.nextReviewDate.isBefore(DateTime.now());
    }).toList();
    notifyListeners();
  }

  String? validateAnswer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an answer';
    }
    return null;
  }

  void submitAnswer(String answer, String correctAnswer) {
  }

  @override
  void dispose() {
    textController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }
}
