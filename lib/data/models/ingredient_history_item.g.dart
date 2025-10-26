// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientHistoryItemAdapter extends TypeAdapter<IngredientHistoryItem> {
  @override
  final int typeId = 2;

  @override
  IngredientHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientHistoryItem(
      action: fields[0] as String,
      qty: fields[1] as double,
      date: fields[2] as DateTime,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientHistoryItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.action)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
