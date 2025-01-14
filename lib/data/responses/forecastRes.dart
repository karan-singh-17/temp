class ForecastRes {
  final num pvEstimate;
  final DateTime periodEnd;
  final Duration period;
  const ForecastRes(
      {required this.pvEstimate,
      required this.periodEnd,
      required this.period});

  factory ForecastRes.fromJson(Map<String, dynamic> json) {
    return ForecastRes(
      pvEstimate: json['pv_power_rooftop'],
      periodEnd: DateTime.parse(json['period_end']),
      period: Duration(minutes: _parsePeriod(json['period'])),
    );
  }
  static int _parsePeriod(String period) {
    final regex = RegExp(r'PT(\d+)M');
    final match = regex.firstMatch(period);
    if (match != null && match.groupCount == 1) {
      return int.parse(match.group(1)!);
    }
    return 0; // Default to 0 if parsing fails
  }
}
