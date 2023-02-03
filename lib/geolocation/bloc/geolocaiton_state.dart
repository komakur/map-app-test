part of 'geolocaiton_bloc.dart';

abstract class GeolocaitonState extends Equatable {
  const GeolocaitonState();

  @override
  List<Object> get props => [];
}

class GeolocaitonLoading extends GeolocaitonState {}

class GeolocationError extends GeolocaitonState {}

class GeolocaitonLoaded extends GeolocaitonState {
  final Position position;
  const GeolocaitonLoaded({required this.position});

  @override
  List<Object> get props => [position];
}
