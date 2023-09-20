import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

bool checkTokenMiddleware() {
  // Check for the presence of the token (or any other condition)

  final accessToken = SharedPreferencesService().prefs.get("access_token");
  if (accessToken == null) {
    return false;
  }

  // Return true if the condition is met; otherwise, return false
  return true;
}
