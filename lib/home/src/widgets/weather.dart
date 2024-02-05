import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:wat_do/common/value.dart';
import 'package:wat_do/home/home.dart';

/// Widget displaying the current weather information. Handles loading states
/// and presents either a loading indicator, a button to fetch weather data,
/// or the weather details if available.
class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return _mainWidget(
          context,
          state,
        );
      },
    );
  }

  Widget _mainWidget(
    BuildContext context,
    WeatherState state,
  ) {
    switch (state.loadState) {
      case LoadState.loading:
        return _buildLoading(context);
      case LoadState.loaded:
        return _buildLoaded(context, state);
    }
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoaded(
    BuildContext context,
    WeatherState state,
  ) {
    late Function()? onPressed;
    final enableStatus = state.status == PermissionStatus.enable;
    if (enableStatus) {
      onPressed = () => context.read<WeatherBloc>().add(
            CurrentWeatherLoaded(),
          );
    } else {
      onPressed = null;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!enableStatus)
          Text(
            AppLocalizations.of(context)!.errorWeatherGeoData,
          ),
        state.weatherInfo.isEmpty
            ? FilledButton(
                onPressed: onPressed,
                child: Text(
                  AppLocalizations.of(context)!.getCurrentWeather,
                ),
              )
            : _weatherWidget(context, state)
      ],
    );
  }

  Widget _weatherWidget(
    BuildContext context,
    WeatherState state,
  ) {
    final city = state.weatherInfo['name'];
    final temperature = state.weatherInfo['main']['temp'].floor().toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonBorderRadius),
            side: const BorderSide(
                width: kBorderSideWidth, color: kButtonBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.currentWeather,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kTitleFontSize,
                  ),
                ),
                Text('${AppLocalizations.of(context)!.city}: $city'),
                Text(
                  '${AppLocalizations.of(context)!.temperature}: $temperature°C',
                ),
              ],
            ),
          ),
        ),
        FilledButton(
          onPressed: () => context.read<WeatherBloc>().add(
                CurrentWeatherLoaded(),
              ),
          child: Text(
            AppLocalizations.of(context)!.updateCurrentWeather,
          ),
        )
      ],
    );
  }
}
