part of 'geolocaiton_bloc.dart';

abstract class GeolocaitonEvent extends Equatable {
  const GeolocaitonEvent();

  @override
  List<Object> get props => [];
}

class LoadGeolocation extends GeolocaitonEvent {}

class UpdateGeolocation extends GeolocaitonEvent {
  final Position position;

  const UpdateGeolocation({required this.position});

  @override
  List<Object> get props => [position];
}
