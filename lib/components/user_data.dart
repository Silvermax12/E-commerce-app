class UserData {
  static final UserData _instance = UserData._internal();

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  String? userName; // Shared variable
}

final userData = UserData(); // Access this instance globally
