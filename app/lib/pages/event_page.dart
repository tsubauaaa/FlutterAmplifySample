import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  final VoidCallback shouldLogOut;
  const EventPage({Key? key, required this.shouldLogOut}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: widget.shouldLogOut,
          ),
        ],
      ),
      body: const Center(
        child: Text('Event Page'),
      ),
    );
  }
}
