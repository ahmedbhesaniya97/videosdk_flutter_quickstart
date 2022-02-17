import 'package:flutter/material.dart';
import 'package:videosdk/rtc.dart';
import 'package:videosdk_flutter_quickstart/join_screen.dart';
import 'package:videosdk_flutter_quickstart/participant_grid_view.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId, token, displayName;
  final bool micEnabled, webcamEnabled;
  const MeetingScreen(
      {Key? key,
      required this.meetingId,
      required this.token,
      required this.displayName,
      this.micEnabled = true,
      this.webcamEnabled = true})
      : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  Meeting? meeting;

  Stream? videoStream;
  Stream? audioStream;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: MeetingBuilder(
        meetingId: widget.meetingId,
        displayName: widget.displayName,
        token: widget.token,
        micEnabled: widget.micEnabled,
        webcamEnabled: widget.webcamEnabled,
        notification: const NotificationInfo(
          title: "Video SDK",
          message: "Video SDK is sharing screen in the meeting",
          icon: "notification_share", // drawable icon name
        ),
        builder: (_meeting) {
          // Called when joined in meeting
          _meeting.on(
            Events.meetingJoined,
            () {
              setState(() {
                meeting = _meeting;
              });

              // Setting meeting event listeners
              setMeetingListeners(_meeting);
            },
          );

          // Showing waiting screen
          if (meeting == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 20),
                    const Text("waiting to join meeting"),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.8),
            appBar: AppBar(
              title: Text(widget.meetingId),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ParticipantGridView(meeting: meeting!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        if (audioStream != null)
                          {_meeting.muteMic()}
                        else
                          {_meeting.unmuteMic()}
                      },
                      child: Text("Mic"),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        if (videoStream != null)
                          {_meeting.disableWebcam()}
                        else
                          {_meeting.enableWebcam()}
                      },
                      child: Text("Webcam"),
                    ),
                    ElevatedButton(
                      onPressed: () => {_meeting.leave()},
                      child: Text("Leave"),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void setMeetingListeners(Meeting meeting) {
    // Called when meeting is ended
    meeting.on(Events.meetingLeft, () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const JoinScreen()),
          (route) => false);
    });

    // Called when stream is enabled
    meeting.localParticipant.on(Events.streamEnabled, (Stream _stream) {
      if (_stream.kind == 'video') {
        setState(() {
          videoStream = _stream;
        });
      } else if (_stream.kind == 'audio') {
        setState(() {
          audioStream = _stream;
        });
      }
    });

    // Called when stream is disabled
    meeting.localParticipant.on(Events.streamDisabled, (Stream _stream) {
      if (_stream.kind == 'video' && videoStream?.id == _stream.id) {
        setState(() {
          videoStream = null;
        });
      } else if (_stream.kind == 'audio' && audioStream?.id == _stream.id) {
        setState(() {
          audioStream = null;
        });
      }
    });
  }

  Future<bool> _onWillPopScope() async {
    meeting?.leave();
    return true;
  }
}
