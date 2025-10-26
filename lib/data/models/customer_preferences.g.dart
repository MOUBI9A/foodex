// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerPreferencesAdapter extends TypeAdapter<CustomerPreferences> {
  @override
  final int typeId = 8;

  @override
  CustomerPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerPreferences(
      customerId: fields[0] as String,
      likedIngredients: (fields[1] as List?)?.cast<String>(),
      dislikedIngredients: (fields[2] as List?)?.cast<String>(),
      allergies: (fields[3] as List?)?.cast<String>(),
      dietaryRestrictions: (fields[4] as List?)?.cast<String>(),
      spiceLevel: fields[5] as int,
      favoriteCuisines: (fields[6] as List?)?.cast<String>(),
      organicPreference: fields[7] as bool,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerPreferences obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.customerId)
      ..writeByte(1)
      ..write(obj.likedIngredients)
      ..writeByte(2)
      ..write(obj.dislikedIngredients)
      ..writeByte(3)
      ..write(obj.allergies)
      ..writeByte(4)
      ..write(obj.dietaryRestrictions)
      ..writeByte(5)
      ..write(obj.spiceLevel)
      ..writeByte(6)
      ..write(obj.favoriteCuisines)
      ..writeByte(7)
      ..write(obj.organicPreference)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
