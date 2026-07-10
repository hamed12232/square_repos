import 'package:hive/hive.dart';

class LocalDataBaseService {
  /// Open box helper to ensure box is open and accessible
  Future<Box> _getBox(String boxName) async {
    // Standardizing on untyped/dynamic Box to avoid Hive TypeMismatch errors
    final name = boxName.toLowerCase();
    if (Hive.isBoxOpen(name)) {
      return Hive.box(name);
    }
    return await Hive.openBox(name);
  }

  /// Save data in box by name
  Future<void> saveData(String boxName, List data) async {
    final box = await _getBox(boxName);
    await box.clear(); // Clear old data
    await box.addAll(data);
  }

  /// Add data to existing box
  Future<void> addData(String boxName, List data) async {
    final box = await _getBox(boxName);
    await box.addAll(data);
  }

  /// Get data from box by name
  Future<List> getData(String boxName) async {
    final box = await _getBox(boxName);
    return box.values.toList();
  }

  /// Clear All data from the Box
  Future<void> clearBox(String boxName) async {
    final box = await _getBox(boxName);
    await box.clear();
  }
}
