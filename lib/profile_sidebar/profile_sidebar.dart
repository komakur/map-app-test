import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

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
        ],
      ),
    );
  }
}
