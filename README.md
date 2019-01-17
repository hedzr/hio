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
    var api = new Api<ApiOpt>()
      ..debugHeader = true
      ..baseUrl = "https://api.github.com/";

    api('users/:user/repos', urlParams: {'user': username})
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
    var api = new Api<ApiOpt>()
      ..debugHeader = true
      ..baseUrl = "https://api.github.com/"
      // using a global callback to parse the json object.
      ..successCB = (data, resp) {
        print('data: $data');
      }
      ..errorCB = (err, resp) {
        print('ERROR: $err');
      };
    
    var c = api('users/:user/repos', method: 'GET', urlParams: {'user': username});
    
    await c.go();
    
    // second call here
    await c.go(urlParams: {'user': 'google'})
      // using special callback for data processing itself
      ..successCB = (data, resp) {
        print('data: $data');
      }
      ..errorCB = (err, resp) {
        print('ERROR: $err');
      };
}
```

#### Define your API class (swapi.co)

```dart
class SwApi extends Api<ApiOpt> {
  SwApi() : super() {
    this
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = 'https://swapi.co/api/'
      ..addOnSendHandler((req, c) {
        return true;
      });
  }

  @override
  String toString() {
    return 'SwApi[]';
  }
}

// and use it:
void run() async {
    var api = SwApi();

    var x = api('people/:id', method: 'GET', urlParams: {'id': 1});
    await x.go();

    await x.go('people/:id', urlParams: {'id': 2});
}
```

### Pre-processing the received data (implements GitHub Api)

```dart

class GithubOpt extends ApiOpt {
  int xRateLimitLimit = 60;
  int xRateLimitRemaining = 59;
  int xRateLimitReset = 1547617535;
  String xGitHubRequestId;
  Map<String, String> links;

  @override
  String toString() {
    return 'GithubApiCall[xRateLimitLimit:$xRateLimitLimit, xRateLimitRemaining:$xRateLimitRemaining, xRateLimitReset: $xRateLimitReset, ${toStringPart()}]';
  }

  GithubOpt();

  GithubOpt.init(
      String method,
      String url,
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams)
      : super.init(method, url, headers, urlParams, queryParams, bodyParams);

//  factory GithubApiCall.create(
//          String method,
//          String url,
//          Map<String, String> headers,
//          Map<String, dynamic> urlParams,
//          Map<String, dynamic> queryParams,
//          Map<String, dynamic> bodyParams) =>
//      GithubApiCall.init(
//          method, url, headers, urlParams, queryParams, bodyParams);
}

class GithubApi extends Api<GithubOpt> {
  GithubApi() : super() {
    this
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = 'https://api.github.com/'
      ..accept = 'application/vnd.github.v3+json'
      ..addOnSendHandler((req, c) => true)
      ..addOnProcessDataHandler(
          (dynamic data, HttpClientResponse resp, GithubOpt cc) {
        resp.headers.forEach((k, values) {
          // 'cache-control',
          //GithubApiCall cc = c;
          cc.links ??= <String, String>{};
          if (k == 'link') {
            for (var ss1 in values[0].split(',')) {
              print('$ss1');
              var ss2 = ss1.split(';');
              var link = trim(ss2[0].trim(), chars: '<>');
              var rel = ss2[1].trim();
              if (rel.startsWith('rel=')) rel = rel.substring(4);
              rel = trim(rel, chars: '"');
              cc.links[rel] = link;
            }
          } else if (k == 'x-ratelimit-limit') {
            cc.xRateLimitLimit = int.tryParse(values[0]) ?? 0;
          } else if (k == 'x-ratelimit-remaining') {
            cc.xRateLimitRemaining = int.tryParse(values[0]) ?? 0;
          } else if (k == 'x-ratelimit-reset') {
            cc.xRateLimitReset = int.tryParse(values[0]) ?? 0;
          } else if (k == 'x-github-request-id') {
            cc.xGitHubRequestId = values[0];
          }
        });
        return data;
      });
  }

  @override
  String toString() {
    return 'GithubApi[]';
  }

  @override
  ApiBroker<GithubOpt> call(String apiEntry,
      {String method = 'GET',
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      Map<String, dynamic> params = const {}}) {
    var opt = GithubOpt.init(
        method, getUrl(apiEntry), headers, urlParams, queryParams, bodyParams);
    print('opt: $opt, getUrl: ${getUrl(apiEntry)}');
    return create(opt);
  }
}

// and use it:
void run() async {
    var api = GithubApi();
    var x = api('users/:user/repos', urlParams: {'user': 'hedzr'})
      ..successCB = (data, resp, c) {
        print('data received: $data');
        print('links: ${c.links}');
      }
      ..errorCB = (err, resp, c) {
        print('ERROR: $err');
      };

    await x.go();

    // make the second call:
    await x.go('users/:user/repos', method: 'GET', urlParams: {'user': 'google'});
}
```




