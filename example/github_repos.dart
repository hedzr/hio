import '../test/apis.dart';

void main() async {
  var api = GithubApi();
  var x = api('users/:user/repos', urlParams: {'user': 'google'})
    ..successCB = (data, resp, c) {
      print('data received: $data');
      print('links: ${c.links}');
    }
    ..errorCB = (err, resp, c) {
      print('ERROR: $err');
    };

  await x.go();

  print('--------------------- github api test ok..');
}
