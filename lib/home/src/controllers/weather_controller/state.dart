part of 'bloc.dart';

enum PermissionStatus { enable, disable }

/// Represents the state of weather-related information in the application.
/// Includes map of weather info, load state and permission status property
final class WeatherState extends Equatable {
  final Map<String, dynamic> weatherInfo;
  final LoadState loadState;
  final PermissionStatus status;

  const WeatherState(
      {required this.weatherInfo,
      required this.loadState,
      required this.status});

  WeatherState copyWith({
    Map<String, dynamic>? weatherInfo,
    required LoadState loadState,
    required PermissionStatus status,
  }) {
    return WeatherState(
      weatherInfo: weatherInfo ?? this.weatherInfo,
      status: status,
      loadState: loadState,
    );
  }

  @override
  List<Object?> get props => [
        weatherInfo,
        loadState,
        status,
      ];
}
