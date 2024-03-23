import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSettingsPage extends StatefulWidget {
  @override
  _ChatSettingsPageState createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize with current date and time
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(3, 7, 18, 1),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBar(
            backgroundColor: const Color.fromRGBO(109, 40, 217, 1),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Chat Settings",
              style: GoogleFonts.jockeyOne(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingOption(
                    title: 'Notifications',
                    description: 'Set Custom Notification Sound',
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white, thickness: 2,),
                  _buildSettingHeading(
                    title: 'Deletion Settings',
                    //description: 'Manage deletion preferences for chats',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSettingSubOption(
                          icon: Icons.delete_forever,
                          title: 'Delete All',
                          onTap: () {
                            _showConfirmationDialog(
                              context,
                              "Delete All Chats?",
                              "Are you sure you want to delete all chats?",
                                  () {
                                // Add logic to delete all chats
                                _deleteAllChats();
                              },
                            );
                            print('Delete all chats');
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildSettingSubOption(
                          icon: Icons.calendar_month,
                          title: 'Set Deletion Date & Time',
                          onTap: () {
                            _showDateTimePickerDialog(context);
                            // Add logic for setting deletion date & time
                            print('Set deletion date & time');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white, thickness: 2,),
                  const SizedBox(height: 10),
                  _buildSettingOption(
                    icon: Icons.block,
                    title: 'Block User',
                    //description: 'Block specific users from chatting with you',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingHeading({
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Text(
        title,
        style: GoogleFonts.jockeyOne(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
  Widget _buildSettingOption({
    IconData? icon,
    required String title,
    String description = '', // Provide a default empty string
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: InkWell(
        onTap: () {
          if (title == 'Block User') {
            _showConfirmationDialog(
              context,
              "Block User?",
              "Are you sure you want to block this user?",
                  () {
                // Add logic to block the user
                _blockUser();
              },
            );
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.jockeyOne(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (icon != null && title == 'Block User') // Only show the icon if the title is 'Block User'
                        Icon(
                          icon,
                          color: icon == Icons.block ? Colors.red : Color.fromRGBO(109, 40, 217, 1),
                          size: 30,
                        ),
                    ],
                  ),
                  if (description.isNotEmpty) // Show description only if it's not empty
                    const SizedBox(height: 10),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      textStyle:  TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSubOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  icon,
                  color: Color.fromRGBO(109, 40, 217, 1),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showDateTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Set Deletion Date & Time"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select a date:"),
                  SizedBox(height: 10),
                  _buildDatePickerWidget(context, setState),
                  SizedBox(height: 10),
                  Text("Select a time:"),
                  SizedBox(height: 10),
                  _buildTimePickerWidget(context, setState),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    // Add logic to save selected date and time
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDatePickerWidget(BuildContext context, StateSetter setState) {
    String formattedDate = "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}";
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _selectDate(context, setState);
        },
        child: Text("Pick Date: $formattedDate"),
      ),
    );
  }


  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget _buildTimePickerWidget(BuildContext context, StateSetter setState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _selectTime(context, setState);
        },
        child: Text("Pick Time: ${_selectedTime.format(context)}"),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, StateSetter setState) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
}
void _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

void _deleteAllChats() {
  // Add logic to delete all chats
}

void _blockUser() {
  // Add logic to block the user
}