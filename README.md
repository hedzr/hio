# hio

[![Build Status](https://travis-ci.org/hedzr/hio.svg?branch=master)](https://travis-ci.org/hedzr/hio)
[![Pub](https://img.shields.io/pub/v/hio.svg)](https://pub.dartlang.org/packages/hio)

Enhanced Http Client for Dart/Flutter.

## Getting Started

This project is a starting point for a Dart [package](https://flutter.io/developing-packages/), a library module containing code that can be shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view our [online documentation](https://flutter.io/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.



### Add dependency

```yaml
dependencies:
  hio: x.x.x  #latest version
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
      ..successCB = (data, resp) {
        print('data: $data');
      }
      ..errorCB = (err, resp) {
        print('ERROR: $err');
      }
      ..go();
  } catch (e) {
    return print(e);
  }
}
```

#### Multiple calls, and use global `successCB` and `errorCB`

```dart
void getSomething(String username) async {
    var api = new Api()
      ..debugHeader = true
      ..baseUrl = "https://api.github.com/";
      ..successCB = (data, resp) {
        print('data: $data');
      }
      ..errorCB = (err, resp) {
        print('ERROR: $err');
      };

    var c = api.get('users/:user/repos', urlParams: {'user': username})

    await c.go();
    
    // second call here
    await c.go(urlParams: {'user': 'google'})
}
```

#### Define your API class

```dart
class SwApi extends Api {
  int xRateLimitLimit = 60;
  int xRateLimitRemaining = 59;
  int xRateLimitReset = 1547617535;
  String xGitHubRequestId;

  SwApi() : super() {
    this
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = 'https://swapi.co/api/'
      ..addOnSendHandler((req) {
        return true;
      })
      ..successCB = (data, resp) {
        print('data: $data');
      }
      ..errorCB = (err, resp) {
        print('ERROR: $err');
      };
  }

  @override
  String toString() {
    return 'SwApi[]';
  }
}

# and use it:
    var api = SwApi();

    var x = api('people/:id', method: 'GET', urlParams: {'id': 1});
    await x.go();

    await api.get('people/:id', urlParams: {'id': 2}).go();
```

#### Preprocessing the received data

```dart
class GithubApi extends Api {
  int xRateLimitLimit = 60;
  int xRateLimitRemaining = 59;
  int xRateLimitReset = 1547617535;
  String xGitHubRequestId;
  Map<String, String> links;

  String trim(String s, {String chars = ' '}) {
    for (var i = 0; i < chars.length; i++) {
      var char = chars[i];
      if (s.startsWith(char)) s = s.substring(1);
      if (s.endsWith(char)) s = s.substring(0, s.length - 1);
    }
    return s;
  }

  GithubApi() : super() {
    this
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = 'https://api.github.com/'
      ..accept = 'application/vnd.github.v3+json'
      ..addOnSendHandler((req) {
        return true;
      })
      ..addOnProcessDataHandler((dynamic data, HttpClientResponse resp) {
        resp.headers.forEach((k, values) {
          // 'cache-control',
          links ??= <String, String>{};
          if (k == 'link') {
            for (var ss1 in values[0].split(',')) {
              print('$ss1');
              var ss2 = ss1.split(';');
              var link = trim(ss2[0].trim(), chars: '<>');
              var rel = ss2[1].trim();
              if (rel.startsWith('rel=')) rel = rel.substring(4);
              rel = trim(rel, chars: '"');
              links[rel] = link;
            }
          } else if (k == 'x-ratelimit-limit') {
            xRateLimitLimit = int.tryParse(values[0]) ?? 0;
          } else if (k == 'x-ratelimit-remaining') {
            xRateLimitRemaining = int.tryParse(values[0]) ?? 0;
          } else if (k == 'x-ratelimit-reset') {
            xRateLimitReset = int.tryParse(values[0]) ?? 0;
          } else if (k == 'x-github-request-id') {
            xGitHubRequestId = values[0];
          }
        });
        return data;
      });
  }

  @override
  String toString() {
    return 'GithubApi[xRateLimitLimit:$xRateLimitLimit, xRateLimitRemaining:$xRateLimitRemaining, xRateLimitReset: $xRateLimitReset]';
  }
}

# and use it:
    var api = GithubApi()
      ..successCB = (data, resp) {
        print('data received: $data');
        print('links: ${api.links}');
      }
      ..errorCB = (err, resp) {
        print('ERROR: $err');
      };

    var x = api('users/:user/repos', urlParams: {'user': 'hedzr'});

    await x.go();
```




