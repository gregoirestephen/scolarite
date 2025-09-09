class Etudiant {
  // Identifiant de l'Etudiant
  final String id;
  // Nom de l'Etudiant
  final String nom;
  // Prenom de l'Etudiant
  final String prenom;
  // Montant Scolarite de l'Etudiant
  final double montantScolarite;
  // Montant de la scolarite Restant pour l'Etudiant
  final double montantReste;
  // Image de l'Etudiant (chemin local)
  final String? imagePath;

  Etudiant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.montantScolarite,
    required this.montantReste,
    required this.imagePath,
  });

  String get fullName => '$nom $prenom';

  Map<String, dynamic> toMap() => {
        'id': id,
        'nom': nom,
        'prenom': prenom,
        'montantScolarite': montantScolarite,
        'montantReste': montantReste,
        'imagePath': imagePath,
      };

  /// Utilise [docId] venant de Firestore comme source principale
  factory Etudiant.fromMap(Map<String, dynamic> m, String docId) => Etudiant(
        id: docId,
        nom: m['nom'] as String? ?? '',
        prenom: m['prenom'] as String? ?? '',
        montantScolarite: (m['montantScolarite'] as num?)?.toDouble() ?? 0.0,
        montantReste: (m['montantReste'] as num?)?.toDouble() ?? 0.0,
        imagePath: m['imagePath'] as String?,
      );
}