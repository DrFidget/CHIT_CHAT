import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/pages/MainDashboard/Calls/CallsTab.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/ChatsTab.dart';
import 'package:ourappfyp/pages/MainDashboard/Groups/GroupsTab.dart';

class AppStructure extends StatefulWidget {
  const AppStructure({super.key});

  @override
  State<AppStructure> createState() => _AppStructureState();
}

class _AppStructureState extends State<AppStructure> {
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
              title: (Text(
                "ChitChat",
                style: GoogleFonts.jockeyOne(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w300,
                ),
              )),
              actions: [
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Color.fromARGB(100, 31, 41, 55),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: "WhatsApp Web",
                      child: Text(
                        "WhatsApp Web",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: "Starred messages",
                      child: Text(
                        "Starred messages",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: "Settings",
                      child: Text(
                        "Settings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    // Handle item selection
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Groups",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Calls",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                  ),
                ],
                indicatorColor: Colors.white,
                indicatorWeight: 4.0,
              )),
          body: TabBarView(
            children: [
              // Contents for Tab 1
              Container(
                color: Colors.red,
                child: ChatsTab(),
              ),
              // Contents for Tab 2
              Container(color: Colors.green, child: GroupsTab()),
              // Contents for Tab 3
              Container(color: Colors.blue, child: CallsTab()),
            ],
          ),
        ));
  }
}
