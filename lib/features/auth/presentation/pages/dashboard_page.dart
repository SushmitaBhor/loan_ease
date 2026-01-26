import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Welcome 👋',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // TEMP text (cards next)
                  Text('Total: ${state.total}'),
                  Text('Approved: ${state.approved}'),
                  Text('Pending: ${state.pending}'),
                  Text('Rejected: ${state.rejected}'),
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
    );
  }
}
