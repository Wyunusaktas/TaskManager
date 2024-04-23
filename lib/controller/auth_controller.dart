import 'package:etkinlikuygulamasi/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider(
  (ref) => Authcontroller(authRepository: ref.watch(authRepositoryProvider)),
);

class Authcontroller {
  final AuthRepository authRepository;

  Authcontroller({required this.authRepository});

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return authRepository.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return authRepository.signUpWithEmailAndPassword(
        email: email, password: password);
  }
}
