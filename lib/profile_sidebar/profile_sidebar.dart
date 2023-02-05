import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'package:map_app_test/auth/auth.dart';

class ProfileSidebar extends StatelessWidget {
  final User user;
  const ProfileSidebar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.username),
            accountEmail: Text(user.email),
            currentAccountPicture: Image.network(user.avatarUrl),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              }
            },
            child: TextButton(
                onPressed: () async {
                  BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                },
                child: const Text('Sign out')),
          )
        ],
      ),
    );
  }
}
