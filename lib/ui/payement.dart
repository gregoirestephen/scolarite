import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/modele/payement.dart';
import 'package:scolarite/providers/etudiant_provider.dart';
import 'package:scolarite/providers/firebase_service_provider.dart';
import 'package:scolarite/providers/payement_provider.dart';
import 'package:scolarite/ui/payement_list.dart';

class PaymentsPage extends ConsumerStatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
  String? selectedStudentId;
  final _amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paiements')),
      body: studentsAsync.when(
        data: (students) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sélectionner l\'étudiant'),
                items: students
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.fullName)))
                    .toList(),
                value: selectedStudentId,
                onChanged: (v) => setState(() => selectedStudentId = v),
              ),
              TextField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (selectedStudentId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sélectionner un étudiant')),
                    );
                    return;
                  }
                  final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0.0;
                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Montant invalide')),
                    );
                    return;
                  }

                  // 🔹 Création du paiement
                  final payment = Payement(
                    id: '',
                    etudiantId: selectedStudentId!,
                    date: DateTime.now(),
                    montant: amount,
                  );
                  await ref.read(paymentsNotifierProvider.notifier).addPayment(payment);

                  // Mise à jour du solde via la méthode dédiée
                  final svc = ref.read(firebaseServiceProvider);
                  final student = await svc.getStudentById(selectedStudentId!);

                  if (student != null) {
                    //recuperation de la somme des paiements
                    final totalPaiements = await svc.getTotalPaymentsForStudent(student.id);
                    print(totalPaiements);
                    // Calcul du nouveau solde
                    double newBalance = 0.0;
                    if (student.montantReste >= 0 || student.montantScolarite >= totalPaiements) {
                      newBalance = (student.montantScolarite - totalPaiements).clamp(0.0, double.infinity);
                    } else {
                      newBalance = 0.0;
                    }
                    // Mise à jour du solde de l'étudiant
                    await svc.updateStudentBalance(student.id, newBalance);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paiement enregistré')),
                  );
                  // vider le champs du formulaire
                  _amountCtrl.clear();

                  //navigation vers la liste des paiements
                  Navigator.push(context, MaterialPageRoute(builder:  (context) => const PaymentsListPage()));
                },
                child: const Text('Enregistrer paiement'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}