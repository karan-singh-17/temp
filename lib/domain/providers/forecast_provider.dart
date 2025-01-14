import 'package:flutter/material.dart';
import 'package:moe/data/responses/forecastRes.dart';

class ForecastProvider extends ChangeNotifier {
  late List<ForecastRes> _forecasts;
  List<ForecastRes> get forecasts => _forecasts;
  void setForecasts(List<ForecastRes> forecasts) {
    _forecasts = forecasts;
    notifyListeners();
  }
}
