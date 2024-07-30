import 'package:flutter/material.dart';
import 'package:flutter_socket_chat/Controllers/socket_controller.dart';
import 'package:flutter_socket_chat/Models/subcription_models.dart';
import 'chat_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final TextEditingController _userNameEditingController;
  late final TextEditingController _roomEditingController;

  @override
  void initState() {
    super.initState();
    _userNameEditingController = TextEditingController();
    _roomEditingController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Initializing and connecting to the socket
      SocketController.get(context)
        ..init()
        ..connect(
          onConnectionError: (data) {
            print(data);
          },
        );
    });
  }

  @override
  void dispose() {
    _userNameEditingController.dispose();
    _roomEditingController.dispose();
    SocketController.get(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socket.IO"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _userNameEditingController,
                decoration: InputDecoration(hintText: "Username"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _roomEditingController,
                decoration: InputDecoration(hintText: "Room Name"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _joinChat,
                child: Text("Join"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinChat() {
    var subscription = Subscription(
      roomName: _roomEditingController.text,
      userName: _userNameEditingController.text,
    );
    // Subscribe and go to the Chat screen
    SocketController.get(context).subscribe(
      subscription,
      onSubscribe: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen()),
        );
      },
    );
  }
}
