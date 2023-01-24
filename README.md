# Introduction
An extension for Shared Preferences supporting better constant values, lists and enums.
With out-of-the-box implementations for the data types bool, String, int and double you can extend classes for creating your very own save systems. 

The system is designed for simple adaption to the shares_preferences package. Therefore all items use a string identifier.
Lists are saved by serializing each list item into a proper string form.

## Example
### Save Items:
Creating Items:
````
final boolItem = BoolSaveItem('bool-item', defaultValue: true);
final stringItem = StringSaveItem('string-item', defaultValue: 'value');
final intItem = IntSaveItem('int-item', defaultValue: 42);
final doubleItem = DoubleSaveItem('double-item', defaultValue: 42.0);
final enumItem = EnumSaveItem<MyEnum>('enum-item', MyEnum.values, MyEnum.valueOne);
````
Loading and modifying items:
````
final stringItem = StringSaveItem('string-item', defaultValue: 'value');

// load the value (default value if no new value has been saved)
var loaded = await stringItem.load();

// saves a new value to the save item
await stringItem.save('new value');

// deletes the current value (when loading again, the default will be used)
await stringItem.delete();
````

### List Save Items:
````
final stringItem = StringListSaveItem('string-item', ['default-1', 'default-2']);
final intItem = IntListSaveItem('int-item', [1, 2, 3]);
final enumItem = EnumListSaveItem<MyEnum>('enum-item', MyEnum.values, [MyEnum.valueOne]);
````

### Default data type values
| Type              | Default               |
|-------------------|-----------------------|
| `BoolSaveItem`    | false                 |
| `StringSaveItem`  | ''                    |
| `IntSaveItem`     | 0                     |
| `DoubleSaveItem`  | 0.0                   |
| `EnumSaveItem`    | Must be set manually` |


## Dependencies
- [shared_preferences](https://pub.dev/packages/path_provider) (the base package supported by this extension)

## Contributing
Contributions to the [GitHub Repository](https://github.com/Schloool/extended-shared-preferences-flutter) are very welcomed.
I also appreciate feature requests as well as bug reports using the [GitHub Issue Board](https://github.com/Schloool/extended-shared-preferences-flutter/issues).