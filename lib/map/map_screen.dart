import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart'
    as auth_repository;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app_test/geolocation/bloc/geolocaiton_bloc.dart';
import 'package:map_app_test/profile_sidebar/profile_sidebar.dart';
import 'package:map_app_test/user/bloc/user_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _getPositionSubscription;

  List<Marker> _markersFromUsers(List<User> users) => users
      .map<Marker>(
        (user) => Marker(
          markerId: MarkerId(user.uuid),
          position: LatLng(user.location!.latitude, user.location!.longitude),
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _getPositionSubscription = Geolocator.getPositionStream().listen((event) {
      BlocProvider.of<GeolocaitonBloc>(context).add(LoadGeolocation());
      BlocProvider.of<UserBloc>(context)
        ..add(WriteUser(
            firebase_auth.FirebaseAuth.instance.currentUser!.uid, '',
            email: firebase_auth.FirebaseAuth.instance.currentUser!.email!,
            longitude: event.longitude,
            latitude: event.latitude))
        ..add(LoadUsers());
    });
  }

  @override
  void dispose() {
    _getPositionSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: ProfileSidebar(
          user: auth_repository.User.fromFirebaseUser(
              context.read<auth_repository.AuthRepository>().getUser())),
      body: BlocBuilder<GeolocaitonBloc, GeolocaitonState>(
        builder: (context, geolocationState) {
          if (geolocationState is GeolocaitonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (geolocationState is GeolocaitonLoaded) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UsersLoaded) {
                  List<User> users = state.users;
                  final markers = _markersFromUsers(users);
                  return GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(geolocationState.position.latitude,
                            geolocationState.position.longitude),
                        zoom: 5),
                    markers: markers.toSet(),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}
