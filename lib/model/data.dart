
class Sensor {
  final String temperature;
  final String humidity;
  final String ppm;
  final DateTime date;

  Sensor(this.temperature, this.humidity, this.ppm, this.date);

  Sensor.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        temperature = json['temperature'] as String,
        humidity = json['humidity'] as String,
        ppm = json['ppm'] as String;
}
