import 'dart:convert';
import 'package:crypto/crypto.dart';

String calculateSecretHash({
  required String clientId,
  required String clientSecret,
  required String username,
}) {
  final key = utf8.encode(clientSecret);
  final message = utf8.encode(username + clientId);
  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(message);
  return base64.encode(digest.bytes);
}
