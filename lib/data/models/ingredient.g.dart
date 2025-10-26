// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final int typeId = 1;

  @override
  Ingredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      id: fields[0] as String,
      name: fields[1] as String,
      quantity: fields[2] as double,
      unit: fields[3] as String,
      expiryDate: fields[4] as DateTime?,
      threshold: fields[5] as int,
      freshness: fields[6] as double,
      category: fields[7] as String,
      storageType: fields[8] as String,
      cost: fields[9] as double,
      history: (fields[10] as List?)?.cast<IngredientHistoryItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.expiryDate)
      ..writeByte(5)
      ..write(obj.threshold)
      ..writeByte(6)
      ..write(obj.freshness)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.storageType)
      ..writeByte(9)
      ..write(obj.cost)
      ..writeByte(10)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
