import 'dart:io';

import 'package:hio/hio.dart';

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
      : super.init(method, url, headers, urlParams, queryParams, bodyParams){
    links ??= <String, String>{};
  }

//  factory GithubApiCall.create(
//          String method,
//          String url,
//          Map<String, String> headers,
//          Map<String, dynamic> urlParams,
//          Map<String, dynamic> queryParams,
//          Map<String, dynamic> bodyParams) =>
//      GithubApiCall.init(
//          method, url, headers, urlParams, queryParams, bodyParams);

  void _parseLinks(String link) {
    for (var ss1 in link.split(',')) {
      print('$ss1');
      var ss2 = ss1.split(';');
      var link = ApiUtil.trim(ss2[0].trim(), chars: '<>');
      var rel = ss2[1].trim();
      if (rel.startsWith('rel=')) rel = rel.substring(4);
      rel = ApiUtil.trim(rel, chars: '"');
      links[rel] = link;
    }
  }

  void parseHeaders(HttpHeaders headers) {
    headers.forEach((k, values) {
      // 'cache-control',
      //GithubApiCall cc = c;
      if (k == 'link') {
        _parseLinks(values[0]);
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
  }
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
            cc.parseHeaders(resp.headers);
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
