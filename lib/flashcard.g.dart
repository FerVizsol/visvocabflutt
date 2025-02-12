// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardAdapter extends TypeAdapter<Flashcard> {
  @override
  final int typeId = 0;

  @override
  Flashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flashcard(
      fields[0] as Uint8List,
      fields[1] as String,
      repetitions: fields[2] as int,
      interval: fields[3] as double,
      easeFactor: fields[4] as double,
    )..nextReviewDate = fields[5] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Flashcard obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.repetitions)
      ..writeByte(3)
      ..write(obj.interval)
      ..writeByte(4)
      ..write(obj.easeFactor)
      ..writeByte(5)
      ..write(obj.nextReviewDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
