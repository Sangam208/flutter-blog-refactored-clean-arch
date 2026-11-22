class ServerExceptions implements Exception {
  final String message;

  ServerExceptions(
    String details, {
    String fallback = 'Something went wrong. Please try again.',
  }) : message = _friendlyMessage(details, fallback);

  static String _friendlyMessage(String details, String fallback) {
    final normalized = details.toLowerCase();

    if (normalized.contains('invalid login credentials') ||
        normalized.contains('invalid email or password') ||
        normalized.contains('user not found')) {
      return 'Email or password is incorrect.';
    }
    if (normalized.contains('email not confirmed')) {
      return 'Please verify your email before logging in.';
    }
    if (normalized.contains('user already registered') ||
        normalized.contains('already been registered')) {
      return 'An account with this email already exists.';
    }
    if (normalized.contains('password should be at least') ||
        normalized.contains('password is too weak')) {
      return 'Choose a stronger password and try again.';
    }
    if (normalized.contains('row-level security') ||
        normalized.contains('permission denied') ||
        normalized.contains('not allowed')) {
      return 'You do not have permission to do that.';
    }
    if (normalized.contains('socketexception') ||
        normalized.contains('failed host lookup') ||
        normalized.contains('connection refused') ||
        normalized.contains('network is unreachable') ||
        normalized.contains('timed out') ||
        normalized.contains('timeout')) {
      return 'Connection problem. Check your internet and try again.';
    }
    if (normalized.contains('jwt') ||
        normalized.contains('refresh token') ||
        normalized.contains('session expired')) {
      return 'Your session expired. Please sign in again.';
    }
    if (normalized.contains('bucket not found')) {
      return 'Image storage is unavailable. Please try again later.';
    }
    if (normalized.contains('rate limit') ||
        normalized.contains('over_email_send_rate_limit')) {
      return 'Too many attempts. Wait a moment and try again.';
    }

    return fallback;
  }
}
