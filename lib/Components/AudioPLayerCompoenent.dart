import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessageWidget extends StatefulWidget {
  final DateTime dateTime;
  final Color backgroundColor;
  final Color textColor;
  final String audioUrl;
  final bool alignLeft;
  final VoidCallback callback;

  const AudioMessageWidget({
    Key? key,
    required this.dateTime,
    required this.backgroundColor,
    required this.textColor,
    required this.audioUrl,
    required this.alignLeft,
    required this.callback,
  }) : super(key: key);

  @override
  _AudioMessageWidgetState createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        _isPlaying = s == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  void _changePlaybackSpeed() {
    if (_playbackSpeed == 1.0) {
      _playbackSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      _playbackSpeed = 2.0;
    } else {
      _playbackSpeed = 1.0;
    }
    _audioPlayer.setPlaybackRate(_playbackSpeed);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: .8,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: widget.textColor,
                    ),
                    onPressed: _togglePlayback,
                  ),
                  Expanded(
                    child: Text(
                      'Audio Message',
                      style: TextStyle(color: widget.textColor),
                    ),
                  ),
                  IconButton(
                    icon: Text(
                      '${_playbackSpeed}x',
                      style: TextStyle(color: widget.textColor),
                    ),
                    onPressed: _changePlaybackSpeed,
                  ),
                ],
              ),
              Slider(
                activeColor: widget.textColor,
                inactiveColor: widget.textColor.withOpacity(0.5),
                value: _position.inSeconds.toDouble(),
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
