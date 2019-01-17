import 'dart:io';

///
///
///
typedef void ApiOkFn(dynamic data, HttpClientResponse resp);
typedef void ApiErrorFn(dynamic err, HttpClientResponse resp);
typedef bool ApiOnSendFn(HttpClientRequest req);
typedef dynamic ApiOnProcessDataFn(dynamic data, HttpClientResponse resp);
