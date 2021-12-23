

class Stat {

  List<double> _avgPPM;
  List<String> _avgStatus;
  double _avgYear;
  String _currentYear;

  List<double> get avgPPM => _avgPPM;
  List<String> get avgStatus => _avgStatus;
  double get avgYear => _avgYear;
  String get currentYear => _currentYear;

  set avgPPM(List<double> value) {
    _avgPPM = value;
  }

  set avgStatus(List<String> value) {
    _avgStatus = value;
  }

  set avgYear(double value) {
    _avgYear = value;
  }

  set currentYear(String value) {
    _currentYear = value;
  }
}


