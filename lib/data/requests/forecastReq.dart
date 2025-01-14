class Forecastreq {
  const Forecastreq(
      {required this.lat,
      required this.long,
      required this.azimuth,
      required this.tilt,
      required this.capacity,
      this.hours = '48',
      this.lossFactor = '0.9'});
  final String lat;
  final String long;
  final String capacity;
  final String tilt;
  final String azimuth;
  final String lossFactor;
  final String hours;
}
