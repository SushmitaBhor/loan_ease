import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_event.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  int _resendCounter = 0;

  AuthBloc() : super(AuthInitial()) {
    on<SendOtp>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(OtpSent(event.phone, _resendCounter));
    });

    on<ResendOtp>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 800));
      _resendCounter++;
      emit(OtpSent(event.phone, _resendCounter));
    });

    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());

      await Future.delayed(const Duration(milliseconds: 800));

      if (event.otp.length != 6) {
        emit(AuthError('Invalid OTP'));
      } else {
        emit(Authenticated());
      }
    });
  }
}
