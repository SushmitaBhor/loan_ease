import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_event.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_state.dart';
import 'package:loan_ease/core/storage/secure_storage.dart';

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
    on<CheckSession>((event, emit) async {
      print('🔥 CheckSession triggered');

      emit(AuthLoading());

      final isLoggedIn = await SecureStorage.isLoggedIn();
      print('🔐 isLoggedIn = $isLoggedIn');

      if (isLoggedIn) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());

      await Future.delayed(const Duration(milliseconds: 800));

      if (event.otp.length != 6) {
        emit(AuthError('Invalid OTP'));
      } else {
        await SecureStorage.setLoggedIn(true);
        emit(Authenticated());
      }
    });
  }
}
