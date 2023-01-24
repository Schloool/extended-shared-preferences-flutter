import 'package:extended_shared_preferences/save_item.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  tearDown(() async => await (await SharedPreferences.getInstance()).clear());

  test('deletes save items', () async {
    final saveItem = StringSaveItem('test-item', defaultValue: 'default');
    await saveItem.save('value');

    expect(await saveItem.load(), 'value');
    expect(await saveItem.delete(), true);
    expect(await saveItem.load(), 'default');
  });

  group('handles primitive data type items', () {
    test('handles bool items correctly', () async {
      final saveItem = BoolSaveItem('test-bool', defaultValue: true);
      expect(await saveItem.load(), true);

      await saveItem.save(false);
      expect(await saveItem.load(), false);
    });

    test('handles string items correctly', () async {
      final saveItem = StringSaveItem('test-string', defaultValue: 'default');
      expect(await saveItem.load(), 'default');

      await saveItem.save('value');
      expect(await saveItem.load(), 'value');
    });

    test('handles integer items correctly', () async {
      final saveItem = IntSaveItem('test-int', defaultValue: 10);
      expect(await saveItem.load(), 10);

      await saveItem.save(15);
      expect(await saveItem.load(), 15);
    });

    test('handles double items correctly', () async {
      final saveItem = DoubleSaveItem('test-double', defaultValue: 10.5);
      expect(await saveItem.load(), moreOrLessEquals(10.5));

      await saveItem.save(15.5);
      expect(await saveItem.load(), moreOrLessEquals(15.5));
    });

    test('handles enum items correctly', () async {
      final saveItem = EnumSaveItem<TestEnum>('test-enum', TestEnum.values, TestEnum.valueOne);
      expect(await saveItem.load(), TestEnum.valueOne);

      await saveItem.save(TestEnum.valueTwo);
      expect(await saveItem.load(), TestEnum.valueTwo);
    });
  });
}

enum TestEnum {
  valueOne, valueTwo,
}