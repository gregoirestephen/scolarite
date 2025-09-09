import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: const Text('Accueil - École'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Card(
              child: ListTile(
              title: Text('Presentation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('MASCOLARITE est une application permettant aux ecoles de gerer au mieux le payement des frais de scolaite par les apprenants', style: TextStyle(fontSize: 16)),
            ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
              title: Text('Objectif', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('MASCOLAITE a pour objectif de faciliter le paiement de la scolarité', style: TextStyle(fontSize: 16)),
            ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
              title: Text('Objectif', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('MASCOLAITE a pour objectif de faciliter le paiement de la scolarité', style: TextStyle(fontSize: 16)),
            ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'students',
            onPressed: () => Navigator.pushNamed(context, '/students'),
            icon: const Icon(Icons.people),
            label: const Text('Etudiants'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'payments',
            onPressed: () => Navigator.pushNamed(context, '/payments'),
            icon: const Icon(Icons.payment),
            label: const Text('Paiements'),
          ),
        ],
      ),
    );
  }
}
