import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class for a given type which can be saved in the local user storage.
abstract class SaveItem<T> {

  /// The key under which the item is saved in local storage.
  final String key;

  /// The default value which is used if no value could be found.
  final T defaultValue;

  SaveItem(this.key, this.defaultValue);

  /// Loads the value from local storage using the specified key.
  Future<T?> load();

  /// Saves a new value to the local storage.
  Future save(T? value);

  /// Gets the shared preferences instance used to save local data.
  Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Deletes the value of this save item.
  /// Returns [true] if deleted successfully, otherwise false.
  Future<bool> delete() async {
    final prefs = await getPrefs();
    if (!prefs.containsKey(key)) return false;

    return await prefs.remove(key);
  }
}

/// A [SaveItem] used to store a boolean value.
class BoolSaveItem extends SaveItem<bool> {

  BoolSaveItem(String key, {bool defaultValue = false}) : super(key, defaultValue);

  @override
  Future<bool> load() {
    return getPrefs().then((prefs) => prefs.getBool(key) ?? defaultValue);
  }

  @override
  Future save(bool? value) {
    return getPrefs().then((prefs) => prefs.setBool(key, value ?? defaultValue));
  }

  /// Switches the bool value to the opposite.
  Future toggle() async {
    bool currentValue = await load();
    return save(!currentValue);
  }
}

/// A [SaveItem] used to store a text value.
class StringSaveItem extends SaveItem<String> {

  StringSaveItem(String key, {String defaultValue = ''}) : super(key, defaultValue);

  @override
  Future<String> load() {
    return getPrefs().then((prefs) => prefs.getString(key) ?? defaultValue);
  }

  @override
  Future save(String? value) {
    return getPrefs().then((prefs) => prefs.setString(key, value ?? defaultValue));
  }
}

/// A [SaveItem] used to store an integer value.
class IntSaveItem extends SaveItem<int> {

  IntSaveItem(String key, {int defaultValue = 0}) : super(key, defaultValue);

  @override
  Future<int> load() {
    return getPrefs().then((prefs) => prefs.getInt(key) ?? defaultValue);
  }

  @override
  Future save(int? value) {
    return getPrefs().then((prefs) => prefs.setInt(key, value ?? defaultValue));
  }
}

/// A [SaveItem] used to store a double value.
class DoubleSaveItem extends SaveItem<double> {

  DoubleSaveItem(String key, {double defaultValue = 0}) : super(key, defaultValue);

  @override
  Future<double> load() {
    return getPrefs().then((prefs) => prefs.getDouble(key) ?? defaultValue);
  }

  @override
  Future save(double? value) {
    return getPrefs().then((prefs) => prefs.setDouble(key, value ?? defaultValue));
  }
}

/// A [SaveItem] used to store an enum value.
class EnumSaveItem<T extends Enum> extends SaveItem<T> {

  /// All possible enum values.
  final List<T> allEnumValues;

  EnumSaveItem(String key, this.allEnumValues, T defaultValue) : super(key, defaultValue);

  @override
  Future<T> load() async {
    String value = await getPrefs().then((prefs) => prefs.getString(key) ?? defaultValue.toString());
    return allEnumValues.firstWhere((e) => e.toString() == value);
  }

  @override
  Future save(T? value) {
    return getPrefs().then((prefs) => prefs.setString(key, value.toString()));
  }
}

