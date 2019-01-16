//import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

///
/// https://dev.to/graphicbeacon/quick-tip-how-to-make-http-requests-dart-56dd
/// https://codeburst.io/quick-tip-how-to-make-http-requests-in-dart-53fc407daf31
///
/// https://webdev.dartlang.org/tutorials/get-data/fetch-data
///
void test1() async {
  var request = await HttpClient().getUrl(
      Uri.parse('https://swapi.co/api/people/1')); // produces a request object
  var response = await request.close(); // sends the request

  // transforms and prints the response
  await for (var contents in response.transform(Utf8Decoder())) {
    print('test1 result:');
    print(contents);
  }
}

void main() async {
  test('test: swapi.co/api/people/1', () async {
    test1();

    print('1');

    await HttpClient()
        .getUrl(Uri.parse('https://swapi.co/api/people/1'))
        .then((request) => request.close()) // sends the request
        .then((response) => response
            .transform(Utf8Decoder())
            .listen(print)); // transforms and prints the response

    print('2');
  });
}
