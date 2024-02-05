import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:wat_do/data/service.dart';
import 'package:wat_do/home/home.dart';

part 'event.dart';
part 'state.dart';

/// BLoC for managing weather-related state. Handles events to load current weather
/// information using [WeatherDataService] and updates the state accordingly.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherDataService weatherDataService;

  WeatherBloc({required this.weatherDataService})
      : super(
          const WeatherState(
            weatherInfo: {},
            loadState: LoadState.loaded,
            status: PermissionStatus.enable,
          ),
        ) {
    on<CurrentWeatherLoaded>(_updateWeatherInfo);
  }

  // updated weather data
  Future<void> _updateWeatherInfo(
    CurrentWeatherLoaded event,
    Emitter<WeatherState> emit,
  ) async {
    emit(
      state.copyWith(
        loadState: LoadState.loading,
        status: PermissionStatus.enable,
      ),
    );

    final weatherInfo = await weatherDataService.getLocationWeather();

    if (weatherInfo.isEmpty) {
      emit(
        state.copyWith(
          weatherInfo: {},
          loadState: LoadState.loaded,
          status: PermissionStatus.disable,
        ),
      );
    } else {
      emit(
        state.copyWith(
          weatherInfo: weatherInfo,
          loadState: LoadState.loaded,
          status: PermissionStatus.enable,
        ),
      );
    }
  }
}
