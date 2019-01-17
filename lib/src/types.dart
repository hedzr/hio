import 'dart:io';

import 'package:hio/src/api_call.dart';

///
///
///
typedef void ApiOkFn<C extends Opt>(dynamic data, HttpClientResponse resp, C c);
typedef void ApiErrorFn<C extends Opt>(dynamic err, HttpClientResponse resp,
    C c);
typedef bool ApiOnSendFn<C extends Opt>(HttpClientRequest req, C c);
typedef dynamic ApiOnProcessDataFn<C extends Opt>(dynamic data,
    HttpClientResponse resp, C c);
