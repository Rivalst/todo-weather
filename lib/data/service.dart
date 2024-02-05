import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'package:wat_do/common/value.dart';
import 'package:wat_do/data/model.dart';
import 'package:wat_do/home/home.dart';

/// Abstract class for data management
abstract class DataService {}

/// A Data Service for management data of all ToDo
/// Includes set data, get data, delete data and update data
class ToDoDataService extends DataService {
  // Set new ToDo to box
  Future<void> setData({
    required ToDoModel model,
  }) async {
    final box = await Hive.openBox<ToDoModel>(_boxName);
    await box.add(model);
    await box.close();
  }

  // Method for getting list of all ToDo or by filter settings
  Future<List<ToDoModel>> getData({
    FilterSettings? settings,
    String? category,
  }) async {
    final box = await Hive.openBox<ToDoModel>(_boxName);
    final List<ToDoModel> listToDo;

    switch (settings) {
      case FilterSettings.all:
        listToDo = box.values.toList();
      case FilterSettings.done:
        listToDo = box.values.where((todo) => todo.isDone == true).toList();
      case FilterSettings.notDone:
        listToDo = box.values.where((todo) => todo.isDone == false).toList();
      case FilterSettings.category:
        listToDo =
            box.values.where((todo) => todo.category == category).toList();
      default:
        listToDo = box.values.toList();
    }

    await box.close();

    return listToDo;
  }

  // Method for update ToDo data
  Future<void> updateData({
    required ToDoModel model,
    required int index,
  }) async {
    final box = await Hive.openBox<ToDoModel>(_boxName);

    await box.putAt(index, model);

    await box.close();
  }

  // Method for delete ToDo from box
  Future<void> deleteData({
    required int index,
  }) async {
    final box = await Hive.openBox<ToDoModel>(_boxName);

    await box.deleteAt(index);
    await box.close();
  }

  final _boxName = 'ToDoBox';
}

/// Service class for fetching weather data from a specified URL.
class WeatherDataService extends DataService {
  // get weather data from current device location
  Future<Map<String, dynamic>> getLocationWeather() async {
    try {
      final locationService = LocationDataService();
      final locationData = await locationService.getCurrentLocation();

      final url =
          '$kWeatherApiUrl?lat=${locationData.$1}&lon=${locationData.$2}&appid=$_apiKey&units=metric';
      // Get weather data data
      final weatherData = await _getData(url);

      return weatherData;
    } catch (e) {
      Logger().log(Level.warning, e);
      return {};
    }
  }

  Future<Map<String, dynamic>> _getData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = response.body;
      return jsonDecode(data) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Bad response. Response status code: ${response.statusCode}, response body: ${response.body}');
    }
  }

  final _apiKey = '900df223f73677a3705eaa7ba19b13bb';
}

/// Service class for obtaining the current device location using the Geolocator package.
class LocationDataService extends DataService {
  // method for getting current device location
  Future<(double, double)> getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // if the user does not specify a location, then send an error
        return Future.error('Location permissions are denied');
      }
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final latitude = position.latitude;
    final longitude = position.longitude;

    final locationData = (latitude, longitude);

    return locationData;
  }
}

/// Service responsible for storing and retrieving language data using Hive storage.
/// It allows setting and getting the selected language, using 'en' for English and 'uk' for Ukrainian.
class LanguageDataService extends DataService {
  Future<void> setData(Language language) async {
    final box = await Hive.openBox<String>(_boxName);
    switch (language) {
      case Language.english:
        box.put('language', 'en');
      case Language.ukrainian:
        box.put('language', 'uk');
    }
    await box.close();
  }

  Future<String> getData() async {
    final box = await Hive.openBox<String>(_boxName);
    final language = box.get('language') ?? 'en';
    await box.close();

    return language;
  }

  final _boxName = 'language';
}
