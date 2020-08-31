class AppErrors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Email already in use';
      default:
        return 'Get an error';
    }
  }
}
