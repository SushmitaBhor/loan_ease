abstract class AuthEvent {}

class SendOtp extends AuthEvent {
  final String phone;
  SendOtp(this.phone);
}

class ResendOtp extends AuthEvent {
  final String phone;
  ResendOtp(this.phone);
}

class VerifyOtp extends AuthEvent {
  final String otp;
  VerifyOtp(this.otp);
}

// ✅ ADD THIS
class CheckSession extends AuthEvent {}

class Logout extends AuthEvent {}
