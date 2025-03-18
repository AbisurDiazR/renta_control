import 'package:renta_control/data/models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel?> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isSignedIn();
}