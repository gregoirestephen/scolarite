import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scolarite/modele/etudiant.dart';
import 'package:scolarite/modele/payement.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String studentsCol = 'etudiants';
  final String paymentsCol = 'payements';

  // ------------------------
  // 🔹 Students
  // ------------------------
  Stream<List<Etudiant>> streamStudents() {
    return _db.collection(studentsCol).snapshots().map(
          (snap) => snap.docs
              .map((d) => Etudiant.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addStudent(Etudiant s) async {
  // on ajoute sans id → Firestore en génère un
  DocumentReference docRef = await _db.collection(studentsCol).add({
    'nom': s.nom,
    'prenom': s.prenom,
    'montantScolarite': s.montantScolarite,
    'montantReste': s.montantReste,
  });

  // mise à jour du champ "id" dans le document
  await docRef.update({'id': docRef.id});
}

  Future<void> updateStudent(Etudiant s) async {
    await _db.collection(studentsCol).doc(s.id).update(s.toMap());
  }

  Future<void> deleteStudent(String id) async {
    await _db.collection(studentsCol).doc(id).delete();
  }

  Future<Etudiant?> getStudentById(String id) async {
  final doc = await _db.collection(studentsCol).doc(id).get();
  if (!doc.exists) return null;
  return Etudiant.fromMap(doc.data()!, doc.id);
}

  Future<void> updateStudentBalance(String studentId, double newBalance) async {
    await _db.collection(studentsCol).doc(studentId).update({
      'montantReste': newBalance,
    });
  }
  // ------------------------
  Stream<List<Payement>> streamPayments() {
    return _db
        .collection(paymentsCol)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Payement.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  //retourne la somme des paiements pour un étudiant donné
  Future<double> getTotalPaymentsForStudent(String studentId) async {
    final querySnap = await _db
        .collection(paymentsCol)
        .where('etudiantId', isEqualTo: studentId)
        .get();

    double total = 0.0;
    for (var doc in querySnap.docs) {
      final data = doc.data();
      total += (data['montant'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  //retourne la liste des paiements pour un étudiant donné
  Stream<List<Payement>> streamPaymentsForStudent(String studentId) {
    return _db
        .collection(paymentsCol)
        .where('etudiantId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Payement.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addPayment(Payement p) async {
  DocumentReference docRef = await _db.collection(paymentsCol).add({
    'etudiantId': p.etudiantId,
    'date': p.date.toIso8601String(),
    'montant': p.montant,
  });

    await docRef.update({'id': docRef.id});
  }

  Future<void> deletePayment(String id) async {
    await _db.collection(paymentsCol).doc(id).delete();
  }
}