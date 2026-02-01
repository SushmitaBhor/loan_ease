import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_ease/core/storage/secure_storage.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_event.dart';
import 'package:loan_ease/features/auth/presentation/bloc/auth_state.dart';
import 'package:loan_ease/features/auth/presentation/pages/login_page.dart';
import 'package:loan_ease/features/auth/presentation/widgets/stat_card.dart';
import 'package:loan_ease/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:loan_ease/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:loan_ease/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(Logout());
                },
              ),
            ],
          ),

          body: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          StatCard(
                            title: 'Total',
                            value: state.total,
                            color: Colors.blue,
                            icon: Icons.assignment,
                          ),
                          StatCard(
                            title: 'Approved',
                            value: state.approved,
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                          StatCard(
                            title: 'Pending',
                            value: state.pending,
                            color: Colors.orange,
                            icon: Icons.hourglass_empty,
                          ),
                          StatCard(
                            title: 'Rejected',
                            value: state.rejected,
                            color: Colors.red,
                            icon: Icons.cancel,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
