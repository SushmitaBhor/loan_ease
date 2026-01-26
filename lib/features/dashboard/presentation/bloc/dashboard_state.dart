abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int total;
  final int approved;
  final int pending;
  final int rejected;

  DashboardLoaded({
    required this.total,
    required this.approved,
    required this.pending,
    required this.rejected,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
