import 'package:test/test.dart';

//import 'package:flutter_test/flutter_test.dart';
//import 'package:hio/hio.dart';

import 'apis.dart';

void main() {
  Future<String> lookUpVersion() async => '1.0.0';

  test('github-api-test', () async {
    print(await lookUpVersion());

//    var api = Api()
//      ..debugHeader = true
//      ..debugBody = false
//      ..baseUrl = 'https://api.github.com/'
//      ..accept = 'application/vnd.github.v3+json'
//      ..addOnSendHandler((req, c) {
//        return true;
//      })
//      ..addOnProcessDataHandler((data, resp, c) {
//        return data;
//      });

    var api = GithubApi();
    var x = api('users/:user/repos', urlParams: {'user': 'hedzr'})
      ..successCB = (data, resp, c) {
        print('data received: $data');
        print('links: ${c.links}');
      }
      ..errorCB = (err, resp, c) {
        print('ERROR: $err');
      };

    await x.go();

    print('--------------------- github api test ok..');
    //await x.go(urlParams: {'user': 'flutter'});
  });
}
