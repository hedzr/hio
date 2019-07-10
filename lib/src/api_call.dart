import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hio/src/api.dart';
import 'package:hio/src/types.dart';

abstract class _Opt {
  factory _Opt.create() {
    return ApiOpt();
  }
}

class ApiOpt with _Opt {
  String method;
  String url;
  Map<String, String> headers;
  Map<String, dynamic> urlParams;
  Map<String, dynamic> queryParams;
  Map<String, dynamic> bodyParams;

  ApiOpt();

  ApiOpt.init(this.method, this.url, this.headers, this.urlParams,
      this.queryParams, this.bodyParams);

  factory ApiOpt.create(String method,
      String url,
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams) =>
      ApiOpt.init(method, url, headers, urlParams, queryParams, bodyParams);

  @override
  String toString() {
    return 'DefaultOpt[$toStringPart()]';
  }

  String toStringPart() {
    return 'method:$method, url:$url';
  }
}

class ApiBroker<AC extends ApiOpt> {
  Api<AC> api;

  AC _pkg;

  ApiOkFn<AC> _successFn1;

  ApiOkFn<AC> get successCB => _successFn1 ?? api.successCB;

  set successCB(ApiOkFn<AC> value) => _successFn1 = value;

  ApiErrorFn<AC> _errorFn1;

  ApiErrorFn<AC> get errorCB => _errorFn1 ?? api.errorCB;

  set errorCB(ApiErrorFn<AC> value) => _errorFn1 = value;

  ApiBroker(this.api, this._pkg);

  factory ApiBroker.create(AC strategy, Api<AC> api) {
    var bac = ApiBroker<AC>(api, strategy);
    return bac;
  }

  void invoke(dynamic data, HttpClientResponse resp) {
    if (successCB != null) successCB(data, resp, _pkg);
  }

  void invokeError(dynamic err, HttpClientResponse resp) {
    if (errorCB != null) errorCB(err, resp, _pkg);
  }

  Future<HttpClientResponse> go({String method,
    String apiEntry,
    Map<String, String> headers,
    Map<String, dynamic> urlParams,
    Map<String, dynamic> queryParams,
    Map<String, dynamic> bodyParams}) async {
    if (method != null && method.isNotEmpty) _pkg.method = method;
    if (apiEntry != null && apiEntry.isNotEmpty) {
      _pkg.url = '${api.baseUrl}$apiEntry';
    }

    _pkg.headers ??= {};
    _pkg.urlParams ??= {};
    _pkg.queryParams ??= {};
    _pkg.bodyParams ??= {};

    if (api.accept != null && api.accept.isNotEmpty) {
      //if (_headers.containsKey(HttpHeaders.acceptHeader)) _headers.remove(HttpHeaders.acceptHeader);
      //_headers.putIfAbsent(HttpHeaders.acceptHeader, () => _api.accept);
      _pkg.headers[HttpHeaders.acceptHeader] = api.accept;
    }

    if (headers != null && headers.isNotEmpty) {
      headers.forEach((k, v) => _pkg.headers.remove(k));
      _pkg.headers.addAll(headers);
    }

    if (urlParams != null && urlParams.isNotEmpty) {
      urlParams.forEach((k, v) => _pkg.urlParams.remove(k));
      _pkg.urlParams.addAll(urlParams);
    }
    if (queryParams != null && queryParams.isNotEmpty) {
      queryParams.forEach((k, v) => _pkg.queryParams.remove(k));
      _pkg.queryParams.addAll(queryParams);
    }
    if (bodyParams != null && bodyParams.isNotEmpty) {
      bodyParams.forEach((k, v) => _pkg.bodyParams.remove(k));
      _pkg.bodyParams.addAll(bodyParams);
    }

    var httpClient = HttpClient();
    if (api.connectionTimeout != null) {
      httpClient.connectionTimeout = api.connectionTimeout;
    }
    if (api.userAgent != null && api.userAgent.isNotEmpty) {
      httpClient.userAgent = api.userAgent;
    } else {
      httpClient.userAgent = DEFAULT_USER_AGENT;
    }

    var uri = _buildUrl(_pkg.url);

    //try {
    return httpClient
        .openUrl(_pkg.method, uri)
        .then((HttpClientRequest request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      if (_pkg.headers != null && _pkg.headers.isNotEmpty) {
        _pkg.headers.forEach((k, v) {
          request.headers.add(k, v);
        });
      }
      request.headers
          .set(HttpHeaders.acceptEncodingHeader, 'gzip, deflate, br');

      for (var fn in api?.onSendFns) {
        if (fn != null && fn(request, _pkg) == false) return request.close();
      }

      if (_pkg.bodyParams != null && _pkg.bodyParams.isNotEmpty) {
        request.write(json.encode(_pkg.bodyParams));
      }

      if (api.debugHeader) {
        print('[api] header: ${request.headers}');
        print('[api] bodyParams: ${_pkg.bodyParams}');
      }

      return request.close();
      //
    }).then((HttpClientResponse response) {
      print('[api] response.statusCode = ${response.statusCode}');

      // Process the response.
      if (response.statusCode == HttpStatus.ok) {
        var jsonX = await utf8.decoder.bind(response).join();

        /// https://api.dartlang.org/stable/2.1.0/dart-convert/dart-convert-library.html
        var data = json.decode(jsonX);

        if (api.debugBody) {
          print('[api] data (json.decoded): $data');
        }

        if (data != null) {
          if (api.onProcessDataFns != null && api.onProcessDataFns.isNotEmpty) {
            for (var fn in api.onProcessDataFns) {
              if (fn != null) data = fn(data, response, _pkg);
            }
          }
          invoke(data, response);
        } else {
          print('[api] json failed: $jsonX');
          invokeError('json error', response);
        }
      } else {
        print('[api] error: response.statusCode = ${response.statusCode}');
        invokeError(response.statusCode, response);
      }
    });
    //} catch (e) {
    //  if (_errorFn != null) _errorFn(e, null);
    //}

//    try {
//      var request = await httpClient.openUrl(method, Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.ok) {
//        var json = await response.transform(utf8.decoder).join();
//
//        /// https://api.dartlang.org/stable/2.1.0/dart-convert/dart-convert-library.html
//        var data = jsonDecode(json);
//        if (_successFn != null) _successFn(data);
//      } else {
//        if (_errorFn != null) _errorFn(response.statusCode, response);
//      }
//    } catch (e) {
//      if (_errorFn != null) _errorFn(e, null);
//    }
  }

  Uri _buildUrl(String urlString) {
    var uri1 = Uri.parse(urlString);

    var qp = <String, dynamic>{};
    qp.addAll(uri1.queryParameters);
    qp.forEach((k, v) => _pkg.queryParams.remove(k));
    qp.addAll(_pkg.queryParams);

    var ps = <String>[];
    for (var el in uri1.pathSegments) {
      if (el.startsWith(':')) {
        var k = el.substring(1);
        if (_pkg.urlParams != null && _pkg.urlParams.containsKey(k)) {
          ps.add(_pkg.urlParams[k].toString());
        } else {
          ps.add(el);
        }
      } else {
        ps.add(el);
      }
    }

    var uri = Uri(
        scheme: uri1.scheme,
        userInfo: uri1.userInfo,
        host: uri1.host,
        port: uri1.port,
        //path: uri1.path,
        pathSegments: ps,
        query: uri1.query == null || uri1.query.isEmpty ? null : uri1.query,
        queryParameters: qp == null || qp.isEmpty ? null : qp,
        fragment: uri1.fragment == null || uri1.fragment.isEmpty
            ? null
            : uri1.fragment);
    print(
        '[api] [${_pkg.method}] url: $uri, q: ${uri.query}, qp: ${uri
            .queryParameters}');
    return uri;
  }

  static const String DEFAULT_USER_AGENT =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3642.0 Safari/537.36';
}
