import 'package:flutter/material.dart';

import 'my_list_tile.dart';



class MyDrawer extends StatelessWidget {
  final void Function()? profileTap;
  final void Function()? signOutTap;
  const MyDrawer({super.key, this.profileTap, this.signOutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 65,
                ),
              ),
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),

              MyListTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: profileTap,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: signOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
