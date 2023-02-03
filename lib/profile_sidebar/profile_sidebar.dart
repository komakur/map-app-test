import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class ProfileSidebar extends StatelessWidget {
  final User user;
  const ProfileSidebar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.uuid),
            accountEmail: Text('${user.email}'),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
