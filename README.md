# hio

Enhanced Http Client for Dart/Flutter.

## Getting Started

This project is a starting point for a Dart [package](https://flutter.io/developing-packages/), a library module containing code that can be shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view our [online documentation](https://flutter.io/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.



### Add dependency

```yaml
dependencies:
  dio: x.x.x  #latest version
```


### Usages

#### Simple get

```dart
import 'package:hio/hio.dart';

void getRepos(String username) async {
  try {
    var api = new Api()
      ..debugHeader = true
      ..baseUrl = "https://api.github.com/";

    api.get('users/:user/repos', urlParams: {'user': username})
      ..success = (data, resp) {
        print('data: $data');
      }
      ..error = (err, resp) {
        print('ERROR: $err');
      }
      ..go();
  } catch (e) {
    return print(e);
  }
}
```

#### Multiple calls

```dart
void getSomething(String username) async {
    var api = new Api()
      ..debugHeader = true
      ..baseUrl = "https://api.github.com/";

    var c = api.get('users/:user/repos', urlParams: {'user': username})
      ..success = (data, resp) {
        print('data: $data');
      }
      ..error = (err, resp) {
        print('ERROR: $err');
      };

    await c.go();
    
    // second call here
    await c.go(urlParams: {'user': 'google'})
}
```







