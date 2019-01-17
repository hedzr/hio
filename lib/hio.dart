library hio;

export 'src/api.dart';
export 'src/api_call.dart';
export 'src/tools.dart';
export 'src/types.dart';

///// A Calculator.
//class Calculator {
//  /// Returns [value] plus 1.
//  int addOne(int value) => value + 1;
//}

//class Api2 {
//  var _ipAddress = 'Unknown';
//
//  _getIPAddress() async {
//    var url = 'https://httpbin.org/ip';
//    var httpClient = new HttpClient();
//
//    String result;
//    try {
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.ok) {
//        var json = await response.transform(utf8.decoder).join();
//
//        /// https://api.dartlang.org/stable/2.1.0/dart-convert/dart-convert-library.html
//        var data = jsonDecode(json);
//        result = data['origin'];
//      } else {
//        result =
//            'Error getting IP address:\nHttp status ${response.statusCode}';
//      }
//    } catch (exception) {
//      result = 'Failed getting IP address';
//    }
//
////    // If the widget was removed from the tree while the message was in flight,
////    // we want to discard the reply rather than calling setState to update our
////    // non-existent appearance.
////    if (!mounted) return;
////
////    setState(() {
////      _ipAddress = result;
////    });
//  }
//}
