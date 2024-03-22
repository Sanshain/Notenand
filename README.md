# note_hand

## The flutter app

### Getting started

Run to install pubspec modules:

```sh
flutter pub get
```

To install specified package:

```
flutter pub add ...
```

Use to generate hive adapters:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Use command to run in same port:

```
flutter run -d chrome --web-port 5555
```

## Use the command to release build on your device:

```
flutter run --release
```

## Another branches:

- **custom_value_notifier_$**: works fine, but requires a little bit template code
(ValueListenableBuilders)


### Useful links:

- [Working with Provider](https://www.8host.com/blog/upravlenie-sostoyaniem-flutter-s-pomoshhyu-provider/)

