import 'package:firebase_database/firebase_database.dart';
import 'data.dart';

class DataDao {
  final DatabaseReference _dataReference =
      FirebaseDatabase.instance.reference().child("data");

  Query getDataQuery() {
    return _dataReference;
  }
}