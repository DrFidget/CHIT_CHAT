import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:ourappfyp/APIS/api_service.dart';

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
  TextEditingController transcriptionText = TextEditingController(text: '');
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
      if (_position == _duration) {
        await _audioPlayer.seek(Duration.zero);
      }
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

  void _transcribeAudio() async {
    try {
      final transcription = await ApiService.transcribeFromUrl(widget.audioUrl);
      setState(() {
        transcriptionText.text = transcription;
      });
      print('Transcription: $transcription');
      // Handle transcription result as needed
    } catch (e) {
      print('Failed to transcribe audio: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

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
                    IconButton(
                      icon: Icon(
                        Icons.text_fields,
                        color: widget.textColor,
                      ),
                      onPressed: _transcribeAudio,
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
              if (transcriptionText.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Transcribed Text: ${transcriptionText.text}",
                      style: GoogleFonts.jockeyOne(
                        color: widget.textColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
