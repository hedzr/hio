import 'dart:convert';
import 'dart:io';

import 'package:hio/src/api.dart';
import 'package:hio/src/types.dart';

///
/// ApiCall
///
class ApiCall {
  Api _api;
  String _method;
  String _url;
  Map<String, String> _headers;
  Map<String, dynamic> _urlParams;
  Map<String, dynamic> _queryParams;
  Map<String, dynamic> _bodyParams;

  static const String DEFAULT_USER_AGENT =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3642.0 Safari/537.36';

  ApiCall(this._api, this._method, this._url, this._headers, this._urlParams,
      this._queryParams, this._bodyParams);

  ApiOkFn _successFn1;

  ApiOkFn get successCB => _successFn1 ?? _api.successCB;

  set successCB(ApiOkFn value) => _successFn1 = value;

  ApiErrorFn _errorFn1;

  ApiErrorFn get errorCB => _errorFn1 ?? _api.errorCB;

  set errorCB(ApiErrorFn value) => _errorFn1 = value;

  Future<HttpClientResponse> go(
      {String method,
      String apiEntry,
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams}) async {
    if (method != null && method.isNotEmpty) _method = method;
    if (apiEntry != null && apiEntry.isNotEmpty)
      _url = '${_api.baseUrl}$apiEntry';

    _headers ??= {};
    _urlParams ??= {};
    _queryParams ??= {};
    _bodyParams ??= {};

    if (_api.accept != null && _api.accept.isNotEmpty) {
      //if (_headers.containsKey(HttpHeaders.acceptHeader)) _headers.remove(HttpHeaders.acceptHeader);
      //_headers.putIfAbsent(HttpHeaders.acceptHeader, () => _api.accept);
      _headers[HttpHeaders.acceptHeader] = _api.accept;
    }

    if (headers != null && headers.isNotEmpty) {
      headers.forEach((k, v) => _headers.remove(k));
      _headers.addAll(headers);
    }

    if (urlParams != null && urlParams.isNotEmpty) {
      urlParams.forEach((k, v) => _urlParams.remove(k));
      _urlParams.addAll(urlParams);
    }
    if (queryParams != null && queryParams.isNotEmpty) {
      queryParams.forEach((k, v) => _queryParams.remove(k));
      _queryParams.addAll(queryParams);
    }
    if (bodyParams != null && bodyParams.isNotEmpty) {
      bodyParams.forEach((k, v) => _bodyParams.remove(k));
      _bodyParams.addAll(bodyParams);
    }

    var httpClient = HttpClient();
    if (_api.connectionTimeout != null)
      httpClient.connectionTimeout = _api.connectionTimeout;
    if (_api.userAgent != null && _api.userAgent.isNotEmpty)
      httpClient.userAgent = _api.userAgent;
    else
      httpClient.userAgent = DEFAULT_USER_AGENT;

    var uri = _buildUrl(_url);

    //try {
    return httpClient.openUrl(_method, uri).then((HttpClientRequest request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      if (_headers != null && _headers.isNotEmpty) {
        _headers.forEach((k, v) {
          request.headers.add(k, v);
        });
      }
      request.headers
          .set(HttpHeaders.acceptEncodingHeader, 'gzip, deflate, br');
      if (_api.onSendFns != null && _api.onSendFns.isNotEmpty) {
        for (var fn in _api.onSendFns) {
          if (fn != null && fn(request) == false) return request.close();
        }
      }
      if (_bodyParams != null && _bodyParams.isNotEmpty) {
        request.write(json.encode(_bodyParams));
      }

      if (_api.debugHeader) {
        print('[api] header: ${request.headers}');
        print('[api] bodyParams: $_bodyParams');
      }

      return request.close();
      //
    }).then((HttpClientResponse response) async {
      print('[api] response.statusCode = ${response.statusCode}');

      // Process the response.
      if (response.statusCode == HttpStatus.ok) {
        var jsonX = await response.transform(utf8.decoder).join();

        /// https://api.dartlang.org/stable/2.1.0/dart-convert/dart-convert-library.html
        var data = json.decode(jsonX);

        if (_api.debugBody) {
          print('[api] data (json.decoded): $data');
        }

        if (data != null) {
          if (_api.onProcessDataFns != null &&
              _api.onProcessDataFns.isNotEmpty) {
            for (var fn in _api.onProcessDataFns) {
              if (fn != null) data = fn(data, response);
            }
          }
          if (successCB != null) successCB(data, response);
        } else {
          print('[api] json failed: $jsonX');
          if (errorCB != null) errorCB('json failed', response);
        }
      } else {
        print('[api] error: response.statusCode = ${response.statusCode}');
        if (errorCB != null) errorCB(response.statusCode, response);
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
    qp.forEach((k, v) => _queryParams.remove(k));
    qp.addAll(_queryParams);

    var ps = <String>[];
    for (var el in uri1.pathSegments) {
      if (el.startsWith(':')) {
        var k = el.substring(1);
        if (_urlParams != null && _urlParams.containsKey(k)) {
          ps.add(_urlParams[k].toString());
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
        '[api] [$_method] url: $uri, q: ${uri.query}, qp: ${uri.queryParameters}');
    return uri;
  }
}
