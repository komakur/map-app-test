import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app_test/geolocation/bloc/geolocaiton_bloc.dart';
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
  @override
  void initState() {
    print('in initState');
    super.initState();
    BlocProvider.of<GeolocaitonBloc>(context).add(LoadGeolocation());
    print('after bloc geo');
  }

  @override
  void dispose() {
    _getPositionSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('in build');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: ProfileSidebar(
          user:
              User.fromFirebaseUser(context.read<AuthRepository>().getUser())),
      body: BlocBuilder<GeolocaitonBloc, GeolocaitonState>(
        builder: (context, geolocationState) {
          if (geolocationState is GeolocaitonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (geolocationState is GeolocaitonLoaded) {
            return GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(geolocationState.position.latitude,
                      geolocationState.position.longitude),
                  zoom: 5),
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
