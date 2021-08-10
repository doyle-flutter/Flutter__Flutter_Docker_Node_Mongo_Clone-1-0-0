import 'package:http/http.dart' as http;

class TodoConnect{

  final String _uri = "http://192.168.25.4";
  final Map<String, String> _header = {"key":"flutter"};

  Future<T> httpGet<T>({
    required String path,
    required Function<T>(http.Response res) res,
  }) async => res(await http.get(
      Uri.parse(this._uri+path),
    headers: _header
  ));

  Future<T> httpPost<T>({
    required String path,
    required Map<String, String> body,
    required Function<T>(http.Response res) res,
  }) async => res(await http.post(
      Uri.parse(this._uri+path),
      headers: _header,
      body: body
  ));
}