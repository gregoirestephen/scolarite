import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/services/auth_service.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      state = state.copyWith(isLoggedIn: true, errorMessage: null);
    } else {
      state = state.copyWith(
        isLoggedIn: false,
        errorMessage: "Identifiants incorrects",
      );
    }
  }

  void logout() {
    state = AuthState.initial();
  }
}