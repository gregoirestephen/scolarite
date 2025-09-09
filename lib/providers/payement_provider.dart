
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scolarite/modele/payement.dart';
import 'package:scolarite/providers/firebase_service_provider.dart';
import 'package:scolarite/services/firebase_service.dart';

final paymentsStreamProvider = StreamProvider<List<Payement>>((ref) {
final svc = ref.watch(firebaseServiceProvider);
return svc.streamPayments();
});


class PaymentsNotifier extends StateNotifier<List<Payement>> {
final FirebaseService _svc;
PaymentsNotifier(this._svc) : super([]) {
_svc.streamPayments().listen((list) => state = list);
}


Future<void> addPayment(Payement p) async {
await _svc.addPayment(p);
}
}


final paymentsNotifierProvider = StateNotifierProvider<PaymentsNotifier, List<Payement>>((ref) {
final svc = ref.watch(firebaseServiceProvider);
return PaymentsNotifier(svc);
});