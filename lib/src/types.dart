import 'dart:io';

import 'package:hio/src/api_call.dart';

///
///
///
typedef void ApiOkFn<C extends ApiOpt>(dynamic data, HttpClientResponse resp,
    C c);
typedef void ApiErrorFn<C extends ApiOpt>(dynamic err, HttpClientResponse resp,
    C c);
typedef bool ApiOnSendFn<C extends ApiOpt>(HttpClientRequest req, C c);
typedef dynamic ApiOnProcessDataFn<C extends ApiOpt>(dynamic data,
    HttpClientResponse resp, C c);
