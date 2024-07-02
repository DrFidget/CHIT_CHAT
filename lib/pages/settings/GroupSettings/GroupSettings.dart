import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';

class GroupSettingsPage extends StatefulWidget {
  final List<dynamic> chatRoomMembers;
  final String AdminID;
  final String LoggedINUser;
  final String GroupID;
  final dynamic chatRoom;

  GroupSettingsPage(this.chatRoomMembers, this.AdminID, this.LoggedINUser,
      this.GroupID, this.chatRoom);

  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  UserFirestoreService _userService = UserFirestoreService();
  List<UserClass> _groupMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroupMembers();
  }

  Future<void> _loadGroupMembers() async {
    try {
      List<UserClass> members =
          await _userService.getUsersByIds(widget.chatRoomMembers);
      setState(() {
        _groupMembers = members;
        _isLoading = false;
      });
      await _preloadImages(members);
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _preloadImages(List<UserClass> members) async {
    for (var member in members) {
      final image = NetworkImage(
        member.imageLink ?? 'https://example.com/default_avatar.jpg',
      );
      await precacheImage(image, context);
    }
  }

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  topinfoOfGroup(widget.chatRoom),
                  Divider(color: Colors.white24),
                  ExpansionTile(
                    leading: Icon(Icons.group,
                        color: Color.fromARGB(255, 109, 40, 217)),
                    title: Text('Group Members',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    children: _groupMembers
                        .map((user) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user
                                          .imageLink ??
                                      'https://example.com/default_avatar.jpg'), // Replace with actual user image URL
                                  radius: 25,
                                ),
                                title: Text(user.name ?? 'Unknown',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Row(
                                  children: [
                                    Text(user.email ?? 'No email',
                                        style:
                                            TextStyle(color: Colors.white70)),
                                    if (user.ID == widget.AdminID)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Text(
                                            'Admin',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  // Handle member tap
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  buildListTile(context, Icons.admin_panel_settings, 'Admin',
                      'Change group admins', () {}),
                  buildListTile(
                      context,
                      Icons.exit_to_app,
                      widget.AdminID == widget.LoggedINUser
                          ? 'Delete Group'
                          : 'Exit Group',
                      widget.AdminID == widget.LoggedINUser
                          ? 'remove the group'
                          : 'leave the group', () async {
                    _showConfirmationDialog();
                  }),
                ],
              ),
            ),
    );
  }

  Container topinfoOfGroup(dynamic chatroom) {
    // Provide default values if properties do not exist
    String imageUrl = 'https://example.com/group_avatar.jpg';
    String name = chatroom['name']?.toString() ?? 'Flutter Group';
    String description = 'Group description or info';

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 30,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 109, 40, 217)),
      title: Text(title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
      onTap: onTap,
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Action'),
          content: Text('Are you sure you want to perform this action?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                final chatBoxFirestoreService CS = chatBoxFirestoreService();
                await CS.leaveGroup(widget.GroupID, widget.LoggedINUser);
                Navigator.pushReplacementNamed(context, '/MainApp');
              },
            ),
          ],
        );
      },
    );
  }
}
