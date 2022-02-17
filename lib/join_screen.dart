import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:videosdk_flutter_quickstart/meeting_screen.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  //Repalce the token with the sample token you generated from the VideoSDK Dashboard
  String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI1ZDcwMDg3My0yNmIzLTRlNzgtYjI2ZS0xYzBiZjRlYmNlNDYiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY0NTAxNDAxNSwiZXhwIjoxNjQ1NjE4ODE1fQ.UP2lVMdXZqRwWf7AUToc8GcHkPCGfWR_jWW9JLIZKWE";

  String _meetingID = "";

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _buttonStyle = TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("VideoSDK RTC"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: _buttonStyle,
              onPressed: () async {
                _meetingID = await createMeeting();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeetingScreen(
                      token: _token,
                      meetingId: _meetingID,
                      displayName: "John Doe",
                    ),
                  ),
                );
              },
              child: const Text("CREATE MEETING"),
            ),
            SizedBox(height: 20),
            const Text(
              "OR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                onChanged: (meetingID) => _meetingID = meetingID,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  fillColor: Theme.of(context).primaryColor,
                  labelText: "Enter Meeting ID",
                  hintText: "Meeting ID",
                  prefixIcon: const Icon(
                    Icons.keyboard,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeetingScreen(
                      meetingId: _meetingID,
                      token: _token,
                      displayName: "John Doe",
                    ),
                  ),
                );
              },
              style: _buttonStyle,
              child: const Text("JOIN MEETING"),
            )
          ],
        ),
      ),
    );
  }

  Future<String> createMeeting() async {
    final Uri getMeetingIdUrl =
        Uri.parse('https://api.videosdk.live/v1/meetings');
    final http.Response meetingIdResponse =
        await http.post(getMeetingIdUrl, headers: {
      "Authorization": _token,
    });

    final meetingId = json.decode(meetingIdResponse.body)['meetingId'];
    return meetingId;
  }
}
