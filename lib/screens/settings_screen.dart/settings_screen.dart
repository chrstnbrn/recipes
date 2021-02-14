import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/screen_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ScreenBody(child: _buildUserInfo(context, user)),
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Column(children: [
      CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
      Text(user.name),
      Text(user.email),
      OutlineButton(
        onPressed: () => _onLogoutClick(context),
        child: const Text('Logout'),
      )
    ]);
  }

  Future<void> _onLogoutClick(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                authProvider.signOut();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
