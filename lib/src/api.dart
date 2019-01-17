import 'package:hio/src/api_call.dart';
import 'package:hio/src/types.dart';

///
/// Using Api class:
///
///
class Api {
  bool _debugHeader = false;

  bool get debugHeader => _debugHeader;

  set debugHeader(bool value) => _debugHeader = value;

  bool debugBody = false;

  String _baseUrl = 'https://api.github.com/';

  String get baseUrl => _baseUrl;

  set baseUrl(String value) => _baseUrl = value;

  String accept;
  Duration connectionTimeout;
  String userAgent;

  List<ApiOnSendFn> _onSendFns;

  List<ApiOnSendFn> get onSendFns => _onSendFns;

  void addOnSendHandler(ApiOnSendFn fn) {
    _onSendFns ??= <ApiOnSendFn>[];
    _onSendFns.add(fn);
  }

  List<ApiOnProcessDataFn> _onProcessDataFns;

  List<ApiOnProcessDataFn> get onProcessDataFns => _onProcessDataFns;

  void addOnProcessDataHandler(ApiOnProcessDataFn fn) {
    _onProcessDataFns ??= <ApiOnProcessDataFn>[];
    _onProcessDataFns.add(fn);
  }

  ApiOkFn successCB;

  ApiErrorFn errorCB;

  ApiCall call(String apiEntry,
      {String method = 'GET',
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: method,
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall get(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'GET',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall head(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'HEAD',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall post(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'POST',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall put(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'PUT',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall delete(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'DELETE',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall connect(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'CONNECT',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall options(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'OPTIONS',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall trace(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'TRACE',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall patch(String apiEntry,
      {Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return _call(apiEntry,
        method: 'PATCH',
        headers: headers,
        urlParams: urlParams,
        queryParams: queryParams,
        bodyParams: bodyParams,
        params: params);
  }

  ApiCall _call(String apiEntry,
      {String method = 'GET',
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
      params = const {}}) {
    return ApiCall(this, method, '$baseUrl$apiEntry', headers, urlParams,
        queryParams, bodyParams);
  }
}
