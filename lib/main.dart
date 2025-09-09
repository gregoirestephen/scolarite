import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/ui/etudiant.dart';
import 'package:scolarite/ui/home.dart';
import 'package:scolarite/ui/login.dart';
import 'package:scolarite/ui/payement.dart';
import 'package:scolarite/ui/payement_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // <--- essentiel
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Gestion Scolarité',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/students': (context) => const StudentsPage(),
        '/payments': (context) => PaymentsListPage(),
        '/add_payment': (context) => PaymentsPage(),
      },
    );
  }
}