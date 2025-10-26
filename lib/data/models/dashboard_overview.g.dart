// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_overview.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardOverviewAdapter extends TypeAdapter<DashboardOverview> {
  @override
  final int typeId = 7;

  @override
  DashboardOverview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardOverview(
      activeOrders: fields[0] as int,
      totalCustomers: fields[1] as int,
      revenueToday: fields[2] as double,
      revenueThisMonth: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardOverview obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.activeOrders)
      ..writeByte(1)
      ..write(obj.totalCustomers)
      ..writeByte(2)
      ..write(obj.revenueToday)
      ..writeByte(3)
      ..write(obj.revenueThisMonth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardOverviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
