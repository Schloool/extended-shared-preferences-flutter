import 'package:extended_shared_preferences/list_save_item.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  tearDown(() async => await (await SharedPreferences.getInstance()).clear());

  test('deletes list save items', () async {
    final saveItem = StringListSaveItem('test-item', ['default-1', 'default-2']);
    await saveItem.save(['new-1', 'new-2']);

    var loaded = await saveItem.load();
    expect(loaded[0], 'new-1');
    expect(loaded[1], 'new-2');
    expect(await saveItem.delete(), true);

    var loadedAfterDelete = await saveItem.load();
    expect(loadedAfterDelete[0], 'default-1');
    expect(loadedAfterDelete[1], 'default-2');
  });

  test('adds list items', () async {
    final saveItem = StringListSaveItem('test-item', ['default-1', 'default-2']);
    saveItem.addItem('new');

    var loaded = await saveItem.load();
    expect(loaded.length, 3);
    expect(loaded.last, 'new');
  });

  test('overwrite list items', () async {
    final saveItem = StringListSaveItem('test-item', ['default']);
    await saveItem.saveAt(0, 'new');

    var loaded = await saveItem.load();
    expect(loaded.length, 1);
    expect(loaded.first, 'new');
  });

  test('insert list items', () async {
    final saveItem = StringListSaveItem('test-item', ['default']);
    await saveItem.insertAt(0, 'new');

    var loaded = await saveItem.load();
    expect(loaded.length, 2);
    expect(loaded.first, 'new');
    expect(loaded.last, 'default');
  });

  group('handles primitive data type item lists', () {
    test('handles string item lists correctly', () async {
      final saveItem = StringListSaveItem('test-string', ['default']);
      expect((await saveItem.load()).first, 'default');

      await saveItem.save(['new']);
      expect((await saveItem.load()).first, 'new');
    });

    test('handles integer item lists correctly', () async {
      final saveItem = IntListSaveItem('test-int', [10]);
      expect((await saveItem.load()).first, 10);

      await saveItem.save([15]);
      expect((await saveItem.load()).first, 15);
    });

    test('handles enum item lists correctly', () async {
      final saveItem = EnumListSaveItem('test-enum', TestEnum.values, [TestEnum.valueOne]);
      expect((await saveItem.load()).first, TestEnum.valueOne);

      await saveItem.save([TestEnum.valueTwo]);
      expect((await saveItem.load()).first, TestEnum.valueTwo);
    });
  });
}

enum TestEnum {
  valueOne, valueTwo,
}