


# Nineti MOE 

This app is part of Nineti's MOE (Modular Energy) system, designed to manage and monitor renewable energy solutions. The app is currently under development and uses the Solcast API to fetch solar power forecasts. It will eventually manage all of Nineti's MOE IoT products.

## Features

- Fetches current location using geolocation.
- Displays location information.
- Fetches solar power forecast data from Solcast API.
- Mock API support for testing purposes.
- User can input location manually.
- Modular management of Nineti's MOE IoT products (development in progress).

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/karan-singh-17/moe-nineti.git
   ```

2. Navigate to the project directory:

   ```bash
   cd moe-nineti
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run --debug -v
   ```

## Usage

### Fetching Solar Power Forecast

The `fetchPVForecast` function is used to fetch solar power forecast data from the Solcast API. It accepts a `Forecastreq` object and an `isTest` flag. If `isTest` is set to `true`, the function will use a mock API for testing purposes. 

#### Example:

```dart
Forecastreq request = Forecastreq(
  lat: '119.305817',
  long: '69.087594',
  azimuth: '-90.0',
  tilt: '36.0',
  capacity: '30',
  lossFactor: '0.9',
  hours: '48',
);

bool isTest = true; // Set to false for production API

List<ForecastRes> forecasts = await fetchPVForecast(request, isTest);
```

## Code Overview

### fetchPVForecast Function

This function fetches solar power forecast data from the Solcast API. It takes the following parameters:

- `Forecastreq request`: The request object containing forecast parameters.
- `bool isTest`: A flag to determine whether to use the mock API or the actual Solcast API.

The function constructs the API URL with query parameters, sends an HTTP GET request, and parses the response into a list of `ForecastRes` objects.

```dart
Future<List<ForecastRes>> fetchPVForecast(Forecastreq request, bool isTest) async {
  final String apiUrl = isTest
      ? 'https://ticket-review-system-flask.onrender.com/api/restricted/solcastMock/'
      : 'https://api.solcast.com.au/data/forecast/rooftop_pv_power/';
  const String apiKey = 'YOUR_API_KEY';
  final Map<String, String> queryParams = {
    'latitude': request.lat,
    'longitude': request.long,
    'azimuth': request.azimuth,
    'tilt': request.tilt,
    'capacity': request.capacity,
    'loss_factor': request.lossFactor,
    'hours': request.hours,
    'period': 'PT30M',
    'output_parameters': 'pv_power_rooftop',
    'format': 'json'
  };

  final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
  final client = http.Client();
  try {
    final response = await client
        .get(uri, headers: {'Authorization': 'Bearer $apiKey'})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> forecastsJson = data['forecasts'];
      final List<ForecastRes> forecasts =
          forecastsJson.map((json) => ForecastRes.fromJson(json)).toList();
      return forecasts;
    } else {
      throw Exception("Failed to fetch data. Status code : ${response.statusCode}");
    }
  } catch (e) {
    print("error: $e");
    return [];
  } finally {
    client.close();
  }
}
```
# Directory Structure

## Root Directory

- `main.dart`: The entry point of the Flutter application.
- `themes.dart`: Contains theme definitions for the app.
- `tree.txt`: A text file representing the directory structure.

## Directories and Files

### `data`
This directory contains files and subdirectories related to data handling, including exceptions, requests, responses, and service implementations.

- **`exceptions`**
  - **`AWSExceptions`**
    - `AuthExcetions.dart`: Contains exception handling logic for AWS authentication.

- **`requests`**
  - `forecastReq.dart`: Handles forecast request operations.

- **`responses`**
  - `CodeDeliveryAWS.dart`: Manages AWS code delivery responses.
  - `forecastRes.dart`: Handles forecast response data.

- **`services`**
  - `NavigationServices.dart`: Provides navigation services.
  - **`AWS`**
    - `aws_services.dart`: Core AWS service implementations.
    - `computeAuthHash.dart`: Contains logic to compute authentication hashes.
    - `customStorage.dart`: Manages custom storage solutions.
  - **`DataStream`**
    - `parse.dart`: Handles parsing of data streams.
    - `webSocketClient.dart`: Manages WebSocket client connections.
    
- **`solcast`**
  - `getForecast.dart`: Fetches forecast data from the Solcast API.

### `domain`
This directory contains domain-specific classes, providers, and view models.

- **`classes`**
  - `utils.dart`: Utility functions and classes.

- **`providers`**
  - `add_provider.dart`: Contains logic for adding providers.
  - `forecast_provider.dart`: Manages forecast-related data provisioning.

- **`viewmodels`**
  - Contains view model classes (no files listed).

### `screens`
This directory includes the screen views and related components for the application.

- **`views`**
  - `energydatascreen.dart`: Screen displaying energy data.
  - `home.dart`: Home screen of the application.

  - **`add_panel`**
    - `angles.dart`: Manages angle settings for panels.
    - `capacity.dart`: Handles capacity-related logic.
    - `forecastView.dart`: Displays forecast information.
    - `location_page.dart`: Manages location settings.
    - `name_page.dart`: Handles panel naming.
    - `pannel_details.dart`: Displays panel details.
    - `review_page.dart`: Review screen before finalizing settings.
  
  - **`authentication`**
    - `changePassModal.dart`: Modal for changing password.
    - `confirmRegistrationModal.dart`: Modal for confirming registration.
    - `login.dart`: Login screen.
    - `resetPasswordModal.dart`: Modal for resetting password.
    - `signup.dart`: Signup screen.

- **`widgets`**
  - `buttons.dart`: Custom button widgets.
  - `customSlider.dart`: Custom slider widget.
  - `custom_text_field.dart`: Custom text field widget.

## Future Scope

- **Integration of IoT Networks:** Future versions of the app will integrate with Nineti's MOE IoT products, allowing real-time monitoring and control of various energy solutions.
- **Real-time Stream Updates:** Implementing real-time data streaming to provide up-to-the-minute updates on solar power forecasts and energy production.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
