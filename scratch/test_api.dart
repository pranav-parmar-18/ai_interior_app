import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final urls = [
    'https://instea.org/ai-home/api/smart-replace/create',
    'https://instea.org/ai-home/api/v2/smart-replace/create',
    'https://instea.org/ai-home/api/smart_replace/create',
    'https://instea.org/ai-home/api/v2/smart_replace/create',
    'https://instea.org/ai-home/api/replace/create',
    'https://instea.org/ai-home/api/v2/replace/create',
  ];

  for (final url in urls) {
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode({}));
      print('$url -> Status: ${response.statusCode}, Body: ${response.body}');
    } catch (e) {
      print('$url -> Error: $e');
    }
  }
}
