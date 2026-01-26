import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_event.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_state.dart';
import 'package:loan_ease/features/auth/presentation/pages/dashboard_page.dart';
import 'package:loan_ease/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  int secondsLeft = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();

    // Auto-focus first OTP box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  void startTimer() {
    timer?.cancel();
    setState(() => secondsLeft = 30);

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => DashboardBloc(),
                    child: const DashboardPage(),
                  ),
                ),
              );
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  'OTP sent to ${widget.phone}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: const InputDecoration(counterText: ''),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                secondsLeft > 0
                    ? Text('Resend OTP in $secondsLeft sec')
                    : TextButton(
                        onPressed: () {
                          startTimer();
                          context.read<AuthBloc>().add(SendOtp(widget.phone));
                        },
                        child: const Text('Resend OTP'),
                      ),

                const SizedBox(height: 20),

                state is AuthLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final enteredOtp = controllers
                              .map((c) => c.text)
                              .join();

                          if (enteredOtp.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter 6-digit OTP'),
                              ),
                            );
                            return;
                          }

                          context.read<AuthBloc>().add(VerifyOtp(enteredOtp));
                        },
                        child: const Text('Verify OTP'),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
