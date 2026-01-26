import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data (replace with API later)
      emit(
        DashboardLoaded(total: 120, approved: 70, pending: 30, rejected: 20),
      );
    });
  }
}
