class AppErrors {
  static String show(String errorCode) {
    print(errorCode);
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'user-not-found':
        return 'User not found or deleted by admin';
      case 'wrong-password':
        return 'Password is wrong, check password';
      default:
        return 'Get an error';
    }
  }
}
