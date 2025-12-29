part of 'home_cubit.dart';

/// {@template home_state}
/// HomeState description
/// {@endtemplate}
class HomeState extends Equatable {
  /// {@macro home_state}
  const HomeState({
    this.sumData = 0,
    this.homeStatus = HomeStatus.initial,
  });

  /// Current sum data
  final int sumData;

  /// Status of the Home screen
  final HomeStatus homeStatus;

  @override
  List<Object> get props => [sumData, homeStatus];

  /// Creates a copy of the current HomeState with property changes
  HomeState copyWith({
    int? sumData,
    HomeStatus? homeStatus,
  }) {
    return HomeState(
      sumData: sumData ?? this.sumData,
      homeStatus: homeStatus ?? this.homeStatus,
    );
  }
}

/// {@template home_state_initial}
/// The initial state of HomeState
/// {@endtemplate}
class HomeInitial extends HomeState {
  /// {@macro home_state_initial}
  const HomeInitial() : super();
}

/// Enum to represent the status of Home screen
enum HomeStatus {
  initial,
  loading,
  success,
  error,
}
