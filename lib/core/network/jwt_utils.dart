import 'dart:convert';

/// Reads the `exp` claim out of a JWT's payload segment without verifying
/// the signature — this is purely a client-side heuristic for deciding
/// when to proactively refresh, never a security check (the backend is the
/// only party that validates the token).
DateTime? jwtExpiry(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final normalized = base64Url.normalize(parts[1]);
    final payload = jsonDecode(utf8.decode(base64Url.decode(normalized)));
    if (payload is! Map<String, dynamic>) return null;
    final exp = payload['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  } catch (_) {
    return null;
  }
}
