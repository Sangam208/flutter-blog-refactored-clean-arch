import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6, // 60% width
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              context.read<AppUserCubit>().requestLogout();
            },
          ),
        ],
      ),
    );
  }
}
