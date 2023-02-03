import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocaiton_event.dart';
part 'geolocaiton_state.dart';

class GeolocaitonBloc extends Bloc<GeolocaitonEvent, GeolocaitonState> {
  final GeolocationRepository _geolocationRepository;
  StreamSubscription? _geolocationSubscription;
  GeolocaitonBloc({required GeolocationRepository geolocationRepository})
      : _geolocationRepository = geolocationRepository,
        super(GeolocaitonLoading()) {
    on<LoadGeolocation>(_onGeolocationLoad);
    on<UpdateGeolocation>(_onGeolocaitonUpdate);
  }

  void _onStarted(LoadGeolocation event, Emitter<GeolocaitonState> emit) {}

  Future<void> _onGeolocationLoad(
      LoadGeolocation event, Emitter<GeolocaitonState> emit) async {
    _geolocationSubscription?.cancel();
    final position = await _geolocationRepository.getCurrentPosition();
    add(UpdateGeolocation(position: position));
  }

  void _onGeolocaitonUpdate(
      UpdateGeolocation event, Emitter<GeolocaitonState> emit) {
    emit(GeolocaitonLoaded(position: event.position));
  }

  @override
  Future<void> close() {
    _geolocationSubscription?.cancel();
    return super.close();
  }
}
