// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientUsageAdapter extends TypeAdapter<IngredientUsage> {
  @override
  final int typeId = 4;

  @override
  IngredientUsage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientUsage(
      ingredientId: fields[0] as String,
      qty: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientUsage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ingredientId)
      ..writeByte(1)
      ..write(obj.qty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DishAdapter extends TypeAdapter<Dish> {
  @override
  final int typeId = 3;

  @override
  Dish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dish(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      chefId: fields[3] as String,
      ingredients: (fields[4] as List).cast<IngredientUsage>(),
      price: fields[5] as double,
      prepTime: fields[6] as int,
      rating: fields[7] as double,
      images: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Dish obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.chefId)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.prepTime)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
