import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:moe/data/requests/forecastReq.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moe/data/responses/forecastRes.dart';

Future<List<ForecastRes>> fetchPVForecast(
    Forecastreq request, bool isTest, bool requiresMock) async {
  final String apiUrl = requiresMock
      ? 'https://ticket-review-system-flask.onrender.com/api/restricted/solcastMock/'
      : 'https://api.solcast.com.au/data/forecast/rooftop_pv_power';
  String apiKey = requiresMock
      ? 'S1sr7CjdRJLHTSdbHzA7GyWBGVDLJf-d'
      : '-umBw3cVbex5wcYxODrumfj98RV0YX7K';
  final Map<String, String> queryParams = {
    'latitude': isTest ? '51.178882' : request.lat,
    'longitude': isTest ? '-1.826215' : request.long,
    'azimuth': request.azimuth,
    'tilt': request.tilt,
    'capacity': request.capacity,
    'loss_factor': request.lossFactor,
    'hours': '18',
    'period': 'PT1H',
    'output_parameters': 'pv_power_rooftop',
    'format': 'json'
  };

  final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
  print(uri);
  final client = http.Client();
  try {
    final response = await client.get(uri, headers: {
      'Authorization': 'Bearer $apiKey'
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> forecastsJson = data['forecasts'];
      final List<ForecastRes> forecasts =
          forecastsJson.map((json) => ForecastRes.fromJson(json)).toList();
      print(forecasts);
      return forecasts;
    } else {
      throw "Failed to fetch data. Status code : ${response.statusCode}";
    }
  } catch (e) {
    client.close();
    Fluttertoast.showToast(msg: "Error: $e");
    print("error: $e");
    return [];
  }
}
