// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taste_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasteProfileAdapter extends TypeAdapter<TasteProfile> {
  @override
  final int typeId = 5;

  @override
  TasteProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasteProfile(
      likedIngredients: (fields[0] as List).cast<String>(),
      dislikedIngredients: (fields[1] as List).cast<String>(),
      allergens: (fields[2] as List).cast<String>(),
      cuisines: (fields[3] as List).cast<String>(),
      prefersSpicy: fields[4] as bool,
      prefersHealthy: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TasteProfile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.likedIngredients)
      ..writeByte(1)
      ..write(obj.dislikedIngredients)
      ..writeByte(2)
      ..write(obj.allergens)
      ..writeByte(3)
      ..write(obj.cuisines)
      ..writeByte(4)
      ..write(obj.prefersSpicy)
      ..writeByte(5)
      ..write(obj.prefersHealthy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasteProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
