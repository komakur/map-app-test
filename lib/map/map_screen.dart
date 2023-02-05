import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_repository/user_repository.dart';

import 'package:map_app_test/geolocation/bloc/geolocaiton_bloc.dart';
import 'package:map_app_test/geolocation/location_service.dart';
import 'package:map_app_test/profile_sidebar/profile_sidebar.dart';
import 'package:map_app_test/user/bloc/user_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _getPositionSubscription;
  final _searchController = TextEditingController();
  User? _user;
  GoogleMapController? _mapController;

  List<Marker> _markersFromUsers(List<User> users) => users
      .map<Marker>(
        (user) => Marker(
          markerId: MarkerId(user.uuid),
          infoWindow: InfoWindow(title: user.username, snippet: user.email),
          position: LatLng(user.location.latitude, user.location.longitude),
        ),
      )
      .toList();

  Future<void> _goToUser() async {
    print('animation');
    final currentPosition = await Geolocator.getCurrentPosition();
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 10),
    ));
  }

  @override
  void initState() {
    super.initState();
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser!;
    _user = User(email: currentUser.email!, uuid: currentUser.uid);
    _getPositionSubscription = Geolocator.getPositionStream().listen((event) {
      BlocProvider.of<UserBloc>(context).add(LoadUsers());
      BlocProvider.of<GeolocaitonBloc>(context).add(LoadGeolocation());
      BlocProvider.of<UserBloc>(context).add(WriteUser(
          firebase_auth.FirebaseAuth.instance.currentUser!.uid, '',
          email: firebase_auth.FirebaseAuth.instance.currentUser!.email!,
          longitude: event.longitude,
          latitude: event.latitude));
    });
  }

  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ProfileSidebar(user: _user!),
      appBar: AppBar(title: const Text('Find user app')),
      body: BlocBuilder<GeolocaitonBloc, GeolocaitonState>(
        builder: (context, geolocationState) {
          if (geolocationState is GeolocaitonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (geolocationState is GeolocaitonLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(hintText: 'Search the city'),
                        onChanged: (value) => print(value),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        LocationService().getPlace(_searchController.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is UsersLoaded) {
                            List<User> users = state.users;
                            final markers = _markersFromUsers(users);
                            return GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              zoomGesturesEnabled: true,
                              onMapCreated: (controller) {
                                setState(() {
                                  _mapController = controller;
                                });
                              },
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      geolocationState.position.latitude,
                                      geolocationState.position.longitude),
                                  zoom: 5),
                              markers: markers.toSet(),
                            );
                          }
                          return const Center(
                              child: Text('Something went wrong'));
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            icon: const Icon(
                              Icons.arrow_circle_right,
                              color: Colors.amberAccent,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () async {
          await _goToUser();
        },
      ),
    );
  }
}
