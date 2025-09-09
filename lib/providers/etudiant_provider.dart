
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/modele/etudiant.dart';
import 'package:scolarite/providers/firebase_service_provider.dart';
import 'package:scolarite/services/firebase_service.dart';

final studentsStreamProvider = StreamProvider<List<Etudiant>>((ref) {
final svc = ref.watch(firebaseServiceProvider);
return svc.streamStudents();
});


final studentsListProvider = StateProvider<List<Etudiant>>((ref) => []);


class StudentsNotifier extends StateNotifier<List<Etudiant>> {
final FirebaseService _svc;
StudentsNotifier(this._svc) : super([]) {
// écoute stream et met à jour l'état
_svc.streamStudents().listen((list) => state = list);
}


Future<void> addStudent(Etudiant s) async {
await _svc.addStudent(s);
}


Future<void> updateStudent(Etudiant s) async {
await _svc.updateStudent(s);
}


Future<void> deleteStudent(String id) async {
await _svc.deleteStudent(id);
}
}


final studentsNotifierProvider = StateNotifierProvider<StudentsNotifier, List<Etudiant>>((ref) {
final svc = ref.watch(firebaseServiceProvider);
return StudentsNotifier(svc);
});