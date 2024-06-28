import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPLayerForAi extends StatefulWidget {
  final DateTime dateTime;
  final Color backgroundColor;
  final Color textColor;
  final String audioUrl;
  final bool alignLeft;
  final VoidCallback callback;

  const AudioPLayerForAi({
    Key? key,
    required this.dateTime,
    required this.backgroundColor,
    required this.textColor,
    required this.audioUrl,
    required this.alignLeft,
    required this.callback,
  }) : super(key: key);

  @override
  _AudioPLayerForAiState createState() => _AudioPLayerForAiState();
}

class _AudioPLayerForAiState extends State<AudioPLayerForAi> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _isLoadingAudio = false;

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
        _isLoadingAudio = false; // Turn off loading when audio starts playing
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        // _position = Duration.zero;
      });
    });

    // Preload the audio
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      setState(() {
        _isLoadingAudio = true; // Set loading state while audio is loading
      });
      await _audioPlayer.setSource(UrlSource(widget.audioUrl));
    } catch (e) {
      print('Failed to load audio: $e');
      // Handle error loading audio
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
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
      await _audioPlayer.resume();
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
              if (_isLoadingAudio)
                Center(
                  child: CircularProgressIndicator(
                    color: widget.textColor,
                  ),
                )
              else
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
                        style: GoogleFonts.jockeyOne(
                          color: widget.textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Text(
                        '${_playbackSpeed}x',
                        style: GoogleFonts.jockeyOne(
                          color: widget.textColor,
                        ),
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
