import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'package:map_app_test/app_theme.dart';
import 'package:map_app_test/auth/bloc/auth_bloc.dart';
import 'package:map_app_test/auth/view/pages/sign_up_page.dart';
import 'package:map_app_test/geolocation/bloc/geolocaiton_bloc.dart';
import 'package:map_app_test/user/bloc/user_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => GeolocationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<GeolocaitonBloc>(
            create: (context) => GeolocaitonBloc(
                geolocationRepository: context.read<GeolocationRepository>())
              ..add(
                LoadGeolocation(),
              ),
          ),
          BlocProvider<UserBloc>(
              create: (context) =>
                  UserBloc(userRepository: context.read<UserRepository>()))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme().theme,
          home: const SignUpPage(),
        ),
      ),
    );
  }
}
