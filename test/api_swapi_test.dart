import 'package:test/test.dart';

//import 'package:flutter_test/flutter_test.dart';
//import 'package:hio/hio.dart';

import 'apis.dart';

void main() {
  test('my first unit test', () {
    var answer = 42;
    expect(answer, 42);
  });

  //Future<String> lookUpVersion() async => '1.0.0';

  test('swapi.co api test', () async {
    var api = SwApi()
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = 'https://swapi.co/api/'
      ..addOnSendHandler((req, c) {
        return true;
      })
      ..addOnProcessDataHandler((data, resp, c) {
        return data;
      });

    var x = api('people/:id', urlParams: {'id': 1})
      ..successCB = (data, resp, c) {
        print('data received: $data');
      }
      ..errorCB = (err, resp, c) {
        print('ERROR: $err');
      };

    await x.go();

    print('--------------------- swapi.co api test ok..');
  });
}
