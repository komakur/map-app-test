import 'package:geolocator/geolocator.dart';

abstract class BaseGeolocationRepository {
  Future<Position?> getCurrentPosition() async {
    return null;
  }
}
