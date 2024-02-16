import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/domain/models/entities/user_profile.dart';

class AuthenticationProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late UserProfile _userProfile;

  UserProfile get userProfile => _userProfile;

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<UserProfile>('userProfile', _userProfile));
  }
}
