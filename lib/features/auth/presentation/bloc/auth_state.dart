abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String phone;
  final int resendKey; // IMPORTANT

  OtpSent(this.phone, this.resendKey);
}

class Authenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
