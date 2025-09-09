class Payement {
  // Identifiant du paiement
  final String id;
  // Référence vers l'étudiant concerné
  final String etudiantId;
  // Date du paiement
  final DateTime date;
  // Montant du paiement
  final double montant;

  Payement({
    required this.id,
    required this.etudiantId,
    required this.date,
    required this.montant,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'etudiantId': etudiantId,
        'date': date.toIso8601String(),
        'montant': montant,
      };

  /// Utilise [docId] venant de Firestore comme source principale
  factory Payement.fromMap(Map<String, dynamic> m, String docId) => Payement(
        id: docId, 
        etudiantId: m['etudiantId'] as String? ?? '',
        date: DateTime.tryParse(m['date'] as String? ?? '') ?? DateTime.now(),
        montant: (m['montant'] as num?)?.toDouble() ?? 0.0,
      );
}