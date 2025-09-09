import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/modele/etudiant.dart';
import 'package:scolarite/providers/etudiant_provider.dart';
import 'package:scolarite/utils/image_helper.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Étudiants')),
      body: studentsAsync.when(
        data: (students) {
          return ListView.separated(
            itemCount: students.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final s = students[i];
              final isSolded = s.montantReste <= 0;
              return ListTile(
                leading: s.imagePath != null && s.imagePath!.isNotEmpty
                    ? CircleAvatar(backgroundImage: FileImage(File(s.imagePath!)))
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(s.fullName),
                subtitle: Text('• Solde: ${s.montantReste.toStringAsFixed(0)}'),
                tileColor: isSolded
                    ? Colors.green.withOpacity(0.12)
                    : Colors.red.withOpacity(0.06),
                onTap: () async {
                  // ouvrir édition
                  final updated = await showDialog<Etudiant?>(
                    context: context,
                    builder: (_) => StudentFormDialog(student: s),
                  );
                  if (updated != null) {
                    await ref.read(studentsNotifierProvider.notifier).updateStudent(updated);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await showDialog<Etudiant?>(
            context: context,
            builder: (_) => const StudentFormDialog(),
          );
          if (created != null) {
            await ref.read(studentsNotifierProvider.notifier).addStudent(created);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StudentFormDialog extends ConsumerStatefulWidget {
  final Etudiant? student;
  const StudentFormDialog({Key? key, this.student}) : super(key: key);

  @override
  ConsumerState<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends ConsumerState<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController(); // Prénom
  final _last = TextEditingController();  // Nom
  final _scolarship = TextEditingController();
  final _balance = TextEditingController();
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      final s = widget.student!;
      _first.text = s.prenom; // ✅ correction
      _last.text = s.nom;     // ✅ correction
      _scolarship.text = s.montantScolarite.toStringAsFixed(0);
      _balance.text = s.montantReste.toStringAsFixed(0);
      _localImagePath = s.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.student == null ? 'Ajouter un étudiant' : 'Modifier l’étudiant'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _first,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _last,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _scolarship,
                decoration: const InputDecoration(labelText: 'Montant Scolarité'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _balance,
                decoration: const InputDecoration(labelText: 'Solde'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),

              if (_localImagePath != null && _localImagePath!.isNotEmpty)
                CircleAvatar(radius: 40, backgroundImage: FileImage(File(_localImagePath!)))
              else
                const CircleAvatar(radius: 40, child: Icon(Icons.person)),

              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Choisir une photo"),
                onPressed: _pickImage,
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (!isValid) return;

                  final student = Etudiant(
                    id: widget.student?.id ?? '',
                    nom: _last.text.trim(),    // ✅ correction
                    prenom: _first.text.trim(), // ✅ correction
                    montantScolarite: double.tryParse(_scolarship.text) ?? 0,
                    montantReste: double.tryParse(_balance.text) ?? 0,
                    imagePath: _localImagePath,
                  );

                  if (widget.student == null) {
                    await ref.read(studentsNotifierProvider.notifier).addStudent(student);
                  } else {
                    await ref.read(studentsNotifierProvider.notifier).updateStudent(student);
                  }

                  Navigator.of(context).pop();
                },
                child: Text(widget.student == null ? 'Ajouter' : 'Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final path = await pickAndSaveImage();
    if (path != null) setState(() => _localImagePath = path);
  }
}
