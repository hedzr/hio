import '../test/apis.dart';

dynamic githubDemo() async {
  var api = GithubApi();
  var x = api('users/:user/repos', urlParams: {'user': 'google'})
    ..successCB = (data, resp, c) {
      print('data received: $data');
      print('links: ${c.links}');
    }
    ..errorCB = (err, resp, c) {
      print('ERROR: $err');
    };

  return x.go();
}

void main() async {
  await githubDemo();

  print('--------------------- github api test ok..');
}
