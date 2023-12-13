/*
 * Author: Alban DAVID
 * Github : https://github.com/AlbanDAVID/cooky-app
 * This file is governed by the GNU General Public License, version 3.0.
 * A copy of the license is included in the LICENSE file at the root of this project.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_names.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoriesNamesAdapter extends TypeAdapter<CategoriesNames> {
  @override
  final int typeId = 1;

  @override
  CategoriesNames read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoriesNames(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoriesNames obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesNamesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
