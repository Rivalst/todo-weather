part of 'bloc.dart';

sealed class WeatherEvent extends Equatable {}

/// Event signaling that the weather data has been loaded
final class CurrentWeatherLoaded extends WeatherEvent {
  @override
  List<Object?> get props => [];
}