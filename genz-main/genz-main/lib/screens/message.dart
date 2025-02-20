import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/base_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final String response = await rootBundle.loadString('assets/messages.json');
    final data = await json.decode(response);
    setState(() {
      _messages = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            final isMe = message['isMe'];

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe) // Show icon only for other users
                    CircleAvatar(
                      backgroundImage: AssetImage(message['icon']),
                      radius: 20,
                    ),
                  SizedBox(width: 8),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['sender'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.green[900] : Colors.grey[900],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          message['message'],
                          style: TextStyle(
                            color: isMe ? Colors.green[900] : Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          message['timestamp'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isMe ? Colors.green[700] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe) // Show icon only for the user
                    CircleAvatar(
                      backgroundImage: AssetImage(message['icon']),
                      radius: 20,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}