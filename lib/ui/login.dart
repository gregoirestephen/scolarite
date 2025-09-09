import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/providers/auth_provider.dart';
import 'package:scolarite/providers/auth_state.dart';
import 'package:scolarite/ui/home.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // // Écoute les changements d'état d'authentification
    // ref.listen<AuthState>(authProvider, (previous, next) {
    //   if (next.isLoggedIn) {
    //     Navigator.pushReplacementNamed(context, '/home');
    //   } else if (next.errorMessage != null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(next.errorMessage!)),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Connexion', style: TextStyle(fontSize: 20)),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images.jpeg', 
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                TextField(
                  controller: _emailCtl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passCtl,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_emailCtl.text =='admin@test.com' && _passCtl.text == '1234') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Identifiants incorrects')),
                      );
                      
                    }
                    // ref.read(authProvider.notifier).login(
                    //       _emailCtl.text.trim(),
                    //       _passCtl.text.trim(),
                    //     );
                  },
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}