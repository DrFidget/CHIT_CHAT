import 'package:flutter/material.dart';

class GroupSettingsPage extends StatefulWidget {
  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 109, 40, 217),
        title: Text('Group Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://example.com/group_avatar.jpg'), // Replace with actual group image URL
                    radius: 30,
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Group',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Group description or info',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white24),
            ExpansionTile(
              leading:
                  Icon(Icons.group, color: Color.fromARGB(255, 109, 40, 217)),
              title: Text('Group Members',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              children: [
                ListTile(
                  title:
                      Text('Member 1', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle member tap
                  },
                ),
                ListTile(
                  title:
                      Text('Member 2', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle member tap
                  },
                ),
                // Add more ListTile widgets for each member
              ],
            ),
            buildListTile(context, Icons.admin_panel_settings, 'Admin',
                'Change group admins'),
            buildListTile(
                context, Icons.exit_to_app, 'Exit Group', 'Leave the group'),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 109, 40, 217)),
      title: Text(title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
      onTap: () {
        // Handle tap
      },
    );
  }
}
