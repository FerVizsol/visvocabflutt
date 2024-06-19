import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  Uint8List image;

  @HiveField(1)
  String label;

  @HiveField(2)
  int repetitions;

  @HiveField(3)
  double interval;

  @HiveField(4)
  double easeFactor;

  @HiveField(5)
  DateTime nextReviewDate;

  Flashcard(this.image, this.label,
      {this.repetitions = 0, this.interval = 1, this.easeFactor = 2.5})
      : nextReviewDate = DateTime.now();

  void update(double grade) {
    double delta = grade - 3.0; // 3 es la calificación promedio
    easeFactor = easeFactor + 0.1 - delta * (0.08 + delta * 0.02);
    easeFactor = easeFactor < 1.3 ? 1.3 : easeFactor; // Asegura que easeFactor no sea menor que 1.3
    repetitions += 1;

    if (repetitions == 1) {
      interval = 1;
    } else if (repetitions == 2) {
      interval = 6;
    } else {
      interval *= easeFactor;
    }

    nextReviewDate = DateTime.now().add(Duration(days: interval.round()));
  }
}

class HiveManager {
  static Future<List<Flashcard>> getFlashcards() async {
    final box = await Hive.openBox<Flashcard>('flashcards');
    return box.values.toList();
  }
}
