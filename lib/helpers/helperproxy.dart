import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:CAPPirote/config/config.dart';


String proxifyImage(String url) {
  if (kIsWeb) {
    return '${Config.apiUrl}image-proxy?url=${Uri.encodeComponent(url)}';
  }
  return url;
}