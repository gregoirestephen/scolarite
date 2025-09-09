class AuthState {
  final bool isLoggedIn;
  final String? errorMessage;

  const AuthState({
    required this.isLoggedIn,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(isLoggedIn: false);

  AuthState copyWith({bool? isLoggedIn, String? errorMessage}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage,
    );
  }
}