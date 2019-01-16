//import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hio/hio.dart';

void main() {
  test('my first unit test', () {
    var answer = 42;
    expect(answer, 42);
  });

  Future<String> lookUpVersion() async => '1.0.0';

  test('swapi.co api test', () async {
    var api = new Api()
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = "https://swapi.co/api/"
      ..addOnSendHandler((req) {
        return true;
      })
      ..addOnProcessDataHandler((data, resp) {
        return data;
      });

    var x = api.get('people/:id', urlParams: {'id': 1})
      ..success = (data, resp) {
        print('data received: $data');
      }
      ..error = (err, resp) {
        print('ERROR: $err');
      };

    await x.go();

    print('--------------------- swapi.co api test ok.');
  });

  test('github api test', () async {
    print(await lookUpVersion());

    var api = new Api()
      ..debugHeader = true
      ..debugBody = false
      ..baseUrl = "https://api.github.com/"
      ..accept = 'application/vnd.github.v3+json'
      ..addOnSendHandler((req) {
        return true;
      })
      ..addOnProcessDataHandler((data, resp) {
        return data;
      });

    var x = api.get('users/:user/repos', urlParams: {'user': 'hedzr'})
      ..success = (data, resp) {
        print('data received: $data');
      }
      ..error = (err, resp) {
        print('ERROR: $err');
      };

    await x.go();

    print('--------------------- github api test ok.');
    //await x.go(urlParams: {'user': 'flutter'});
  });
}
