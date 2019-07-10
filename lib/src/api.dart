import 'package:hio/src/api_call.dart';
import 'package:hio/src/types.dart';

class ApiUtil {
  static String trim(String s, {String chars = ' '}) {
    for (var i = 0; i < chars.length; i++) {
      var char = chars[i];
      if (s.startsWith(char)) s = s.substring(1);
      if (s.endsWith(char)) s = s.substring(0, s.length - 1);
    }
    return s;
  }
}

///
/// Using Api class:
///
///
class Api<AC extends ApiOpt> extends ApiUtil {
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

  // TODO idleTimeout, autoUncompress
  // TODO basic auth, certs and ignore, ...

  List<ApiOnSendFn<AC>> _onSendFns;

  List<ApiOnSendFn<AC>> get onSendFns => _onSendFns;

  void addOnSendHandler(ApiOnSendFn<AC> fn) {
    _onSendFns ??= <ApiOnSendFn<AC>>[];
    _onSendFns.add(fn);
  }

  List<ApiOnProcessDataFn<AC>> _onProcessDataFns;

  List<ApiOnProcessDataFn<AC>> get onProcessDataFns => _onProcessDataFns;

  void addOnProcessDataHandler(ApiOnProcessDataFn<AC> fn) {
    _onProcessDataFns ??= <ApiOnProcessDataFn<AC>>[];
    _onProcessDataFns.add(fn);
  }

  ApiOkFn<AC> successCB;

  ApiErrorFn<AC> errorCB;

//  AC call(String apiEntry,
//      {String method = 'GET',
//      Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: method,
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC get(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'GET',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC head(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'HEAD',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC post(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'POST',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC put(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'PUT',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC delete(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'DELETE',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC connect(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'CONNECT',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC options(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'OPTIONS',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC trace(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'TRACE',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }
//
//  AC patch(String apiEntry,
//      {Map<String, String> headers,
//      Map<String, dynamic> urlParams,
//      Map<String, dynamic> queryParams,
//      Map<String, dynamic> bodyParams,
//      Map<String, dynamic> params = const {}}) {
//    return _call(apiEntry,
//        method: 'PATCH',
//        headers: headers,
//        urlParams: urlParams,
//        queryParams: queryParams,
//        bodyParams: bodyParams,
//        params: params);
//  }

  String getUrl(String apiEntry) => '$baseUrl$apiEntry';

  final List<ApiBroker<AC>> _opts = [];

  ApiBroker<AC> create(AC strategy) {
    var x = _createOpt(strategy);
    _opts.add(x);
    return x;
  }

  ApiBroker<AC> _createOpt(AC strategy) => ApiBroker<AC>.create(strategy, this);

  /// `call(...)` should be invoked only from an Api-derived class with
  /// AC=[ApiOpt].
  ///
  ApiBroker<AC> call(String apiEntry,
      {String method = 'GET',
      Map<String, String> headers,
      Map<String, dynamic> urlParams,
      Map<String, dynamic> queryParams,
      Map<String, dynamic> bodyParams,
        Map<String, dynamic> params = const {}}) {
    var opt = ApiOpt.init(
        method, getUrl(apiEntry), headers, urlParams, queryParams, bodyParams);
    return create(opt as AC);
  }
}
