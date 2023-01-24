import 'package:extended_shared_preferences/save_item.dart';

/// Abstract base class for a list of items which is serializable using a string representation.
abstract class ListSaveItem<T> extends SaveItem<List<T>> {

  ListSaveItem(String key, List<T> defaultValue) : super(key, defaultValue);

  T deserializeItem(String serializedItem);

  String serializeItem(T item);

  Future<void> addItem(T item) async {
    var currentList = await load();
    currentList.add(item);
    await save(currentList);
  }

  @override
  Future<List<T>> load() {
    return getPrefs().then((prefs) => prefs.getStringList(key)?.map((e) => deserializeItem(e)).toList() ?? defaultValue);
  }

  @override
  Future save(List<T>? value) {
    return getPrefs().then((prefs) => prefs.setStringList(key, _serializeListItems(value) ?? _serializeListItems(defaultValue)!));
  }

  List<String>? _serializeListItems(List<T>? items) {
    return items?.map((e) => serializeItem(e)).toList();
  }

  Future saveAt(int index, T value) async {
    List<T> current = await load();
    current[index] = value;

    await save(current);
  }

  Future insertAt(int index, T value) async {
    List<T> current = await load();
    current.insert(index, value);

    await save(current);
  }
}

/// A [ListSaveItem] used to store a list of strings.
class StringListSaveItem extends ListSaveItem<String> {

  StringListSaveItem(String key, List<String> defaultValue) : super(key, defaultValue);

  @override
  String deserializeItem(String serializedItem) => serializedItem;

  @override
  String serializeItem(String item) => item;
}

/// A [ListSaveItem] used to store a list of integers.
class IntListSaveItem extends ListSaveItem<int> {

  static const int defaultValueWhenNotDeserializable = 0;

  IntListSaveItem(String key, List<int> defaultValue) : super(key, defaultValue);

  @override
  int deserializeItem(String serializedItem) {
    try {
      return int.parse(serializedItem);
    } catch (e) {
      return defaultValueWhenNotDeserializable;
    }
  }

  @override
  String serializeItem(int item) => item.toString();
}

class EnumListSaveItem<T extends Enum> extends ListSaveItem<T> {

  final List<T> allEnumValues;

  EnumListSaveItem(String key, this.allEnumValues, List<T> defaultValue) : super(key, defaultValue);

  @override
  T deserializeItem(String serializedItem) {
    return allEnumValues.firstWhere((e) => e.toString() == serializedItem);
  }

  @override
  String serializeItem(T item) {
    return item.toString();
  }

}