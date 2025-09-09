class AuthService {
  Future<bool> login(String email, String password) async {
    // Exemple de login simple (à remplacer par FirebaseAuth si besoin)
    await Future.delayed(const Duration(seconds: 1)); // Simule un appel réseau

    if (email == "admin@test.com" && password == "1234") {
      return true;
    }
    return false;
  }
}