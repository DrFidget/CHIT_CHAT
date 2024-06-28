import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/pages/MainDashboard/Calls/CallsTab.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/ChatsTab.dart';
import 'package:ourappfyp/pages/MainDashboard/Groups/GroupsTab.dart';
import 'package:ourappfyp/types/UserClass.dart';

class AppStructure extends StatefulWidget {
  const AppStructure({super.key});

  @override
  State<AppStructure> createState() => _AppStructureState();
}

class _AppStructureState extends State<AppStructure> {
  // Handler function for popup menu item selection
  void _handlePopupMenuSelection(String value) async {
    switch (value) {
      case 'Settings':
        Navigator.pushNamed(context, '/Settings');
        break;
      case 'Profile Settings':
        Navigator.pushNamed(context, '/profileSettings');
        break;
      case 'Log out':
        final _myBox = Hive.box<UserClass>('userBox');
        final clearingPreviousLocalStorage = await _myBox.get(1);
        if (clearingPreviousLocalStorage != null) {
          print("********************Deleting--------------------");
          try {
            await _myBox.delete(1);
          } catch (E) {
            print("+++++++++ deleting error ${E}");
          }
        }
        Navigator.pushNamed(context, '/');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(3, 7, 18, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(109, 40, 217, 1),
          leading: BackButton(
            color: Colors.white,
            onPressed: () => {},
          ),
          title: Text(
            "ChitChat",
            style: GoogleFonts.jockeyOne(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: [
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: Color.fromARGB(100, 31, 41, 55),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: "Profile Settings",
                  child: Text(
                    "Profile Settings",
                    style: GoogleFonts.jockeyOne(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Log out",
                  child: Text(
                    "Log out",
                    style: GoogleFonts.jockeyOne(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              onSelected: _handlePopupMenuSelection, // Call handler function
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Chats",
                  style: GoogleFonts.jockeyOne(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Groups",
                  style: GoogleFonts.jockeyOne(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Calls",
                  style: GoogleFonts.jockeyOne(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ChatsTab(),
            ),
            Container(color: Colors.green, child: GroupsTab()),
            Container(color: Colors.blue, child: CallsTab()),
          ],
        ),
      ),
    );
  }
}
