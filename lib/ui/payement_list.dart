import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/modele/payement.dart';
import 'package:scolarite/providers/payement_provider.dart';
import 'package:scolarite/providers/etudiant_provider.dart';

class PaymentsListPage extends ConsumerWidget {
  const PaymentsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsStreamProvider);
    final studentsAsync = ref.watch(studentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Historique des paiements")),
      body: paymentsAsync.when(
        data: (payments) {
          return studentsAsync.when(
            data: (students) {
              // Crée un map pour accéder rapidement au nom complet
              final studentMap = {for (var s in students) s.id: s.fullName};

              if (payments.isEmpty) {
                return const Center(child: Text("Aucun paiement effectué"));
              }

              return ListView.separated(
                itemCount: payments.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final p = payments[i];
                  final studentName = studentMap[p.etudiantId] ?? "Inconnu";
                  return Card(
                    child: ListTile(
                    title: Text(studentName),
                    subtitle: Text(
                      "Montant: ${p.montant.toStringAsFixed(0)} XOF\nDate: ${p.date.toLocal().toString().split(' ')[0]}",
                    ),
                    leading: const Icon(Icons.payment),
                  ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text("Erreur: $e")),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Erreur: $e")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addPayment',
        onPressed: () => Navigator.pushNamed(context, '/add_payment'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau Paiement'),
      ),
    );
  }
}