import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:just_audio/just_audio.dart' as jsAudio;
import 'package:media_app/sound_player/utils.dart';
import 'colors.dart';
import 'contact_noises.dart';
import 'noises.dart';

class SoundPlayer extends StatefulWidget {
  SoundPlayer({
    Key? key,
    required this.me,
    this.audioSrc,
    this.audioFile,
    this.duration,
    this.formatDuration,
    this.showDuration = false,
    this.waveForm,
    this.noiseCount = 27,
    this.meBgColor = AppColors.pink,
    this.contactBgColor = const Color(0xffffffff),
    this.contactFgColor = AppColors.pink,
    this.contactCircleColor = Colors.red,
    this.mePlayIconColor = Colors.white,
    this.contactPlayIconColor = Colors.black26,
    this.radius = 12,
    this.contactPlayIconBgColor = Colors.grey,
    this.meFgColor = const Color(0xffffffff),
    this.played = false,
    this.onPlay,
    this.timeSent,
    this.senderName,
    this.receiverName,
    this.senderAvatar,
    this.receiverAvatar,
  }) : super(key: key);

  final String? audioSrc;
  Future<File>? audioFile;
  final Duration? duration;
  final bool showDuration;
  final List<double>? waveForm;
  final double radius;
  final String? timeSent;
  final String? senderName;
  final String? senderAvatar;
  final String? receiverAvatar;
  final String? receiverName;
  final int noiseCount;
  final Color meBgColor,
      meFgColor,
      contactBgColor,
      contactFgColor,
      contactCircleColor,
      mePlayIconColor,
      contactPlayIconColor,
      contactPlayIconBgColor;
  final bool played, me;
  Function()? onPlay;
  Duration Function(Duration duration)? formatDuration;

  @override
  // ignore: library_private_types_in_public_api
  _SoundPlayerState createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer>
    with SingleTickerProviderStateMixin {
  late StreamSubscription stream;
  final AudioPlayer _player = AudioPlayer();
  final double maxNoiseHeight = 6.w(), noiseWidth = 50.5.w();
  Duration? _audioDuration;
  double maxDurationForSlider = .0000001;
  bool _isPlaying = false, x2 = false, _audioConfigurationDone = false;
  int duration = 00;
  String _remainingTime = '';

  AnimationController? _controller;
  Duration time = const Duration();
  @override
  void initState() {
    widget.formatDuration ??= (Duration duration) {
      return duration;
    };

    _setDuration();
    super.initState();
    stream = _player.onPlayerStateChanged.listen((event) {
      switch (event) {
        case PlayerState.stopped:
          break;
        case PlayerState.playing:
          setState(() => _isPlaying = true);
          break;
        case PlayerState.paused:
          setState(() => _isPlaying = false);
          break;
        case PlayerState.completed:
          _player.seek(const Duration(milliseconds: 0));
          setState(() {
            duration = _audioDuration!.inMilliseconds;
            time = widget.formatDuration!(_audioDuration!);
          });
          break;
        default:
          break;
      }
    });
    _player.onPositionChanged.listen(
      (Duration time) => setState(
        () => this.time = time,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _sizerChild(context);

  Container _sizerChild(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: .8.w()),
        constraints: BoxConstraints(maxWidth: 100.w() * .8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.me
                  ? CircleAvatar(
                      radius: 20,
                      child: widget.senderAvatar == null
                          ? Text(widget.senderName!.substring(0, 1))
                          : Image.network(widget.senderAvatar!),
                    )
                  : const SizedBox.shrink(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      _playButton(context),
                      const SizedBox(width: 10),
                      _noise(context)
                    ],
                  ),
                  _durationWithNoise(),
                ],
              ),
              !widget.me
                  ? CircleAvatar(
                      radius: 20,
                      child: widget.receiverAvatar == null
                          ? Text(widget.receiverName!.substring(0, 1))
                          : Image.network(widget.receiverAvatar!),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );

  Widget _playButton(BuildContext context) => InkWell(
        child: InkWell(
          onTap: () => !_audioConfigurationDone ? null : _changePlayingStatus(),
          child: !_audioConfigurationDone
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                )
              : Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: widget.me
                      ? widget.mePlayIconColor
                      : widget.contactPlayIconColor,
                  size: 10.w(),
                ),
        ),
      );

  Widget _durationWithNoise() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(time.inMinutes.remainder(60));
    final seconds = twoDigits(time.inSeconds.remainder(60));

    return Row(
      children: [
        Text(
          "$minutes:$seconds",
          style: TextStyle(
            fontSize: 10,
            color: widget.me ? widget.meFgColor : widget.contactFgColor,
          ),
        ),
        const SizedBox(width: 80),
        Text(
          widget.timeSent!,
          style: const TextStyle(fontSize: 10, color: Colors.white60),
        )
      ],
    );
  }

  /// Noise widget of audio.
  Widget _noise(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final newTHeme = theme.copyWith(
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        minThumbSeparation: 0,
      ),
    );

    return Theme(
      data: newTHeme,
      child: SizedBox(
        height: 6.5.w(),
        width: noiseWidth,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            const Noises(),
            if (_audioConfigurationDone)
              AnimatedBuilder(
                animation:
                    CurvedAnimation(parent: _controller!, curve: Curves.ease),
                builder: (context, child) {
                  return Positioned(
                    left: _controller!.value,
                    child: Container(
                      color: const Color(0xff16a464).withOpacity(.4),
                      width: noiseWidth,
                      height: 6.w(),
                    ),
                  );
                },
              ),
            Opacity(
              opacity: .0,
              child: Container(
                width: noiseWidth,
                color: Colors.amber.withOpacity(0),
                child: Slider(
                  min: 0.0,
                  max: maxDurationForSlider,
                  onChangeStart: (__) => _stopPlaying(),
                  onChanged: (_) => _onChangeSlider(_),
                  value: duration + .0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _speed(BuildContext context) => InkWell(
  //       onTap: () => _toggle2x(),
  //       child: Container(
  //         alignment: Alignment.center,
  //         padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.6.w),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(2.8.w),
  //           color: widget.meFgColor.withOpacity(.28),
  //         ),
  //         width: 9.8.w,
  //         child: Text(
  //           !x2 ? '1X' : '2X',
  //           style: TextStyle(fontSize: 9.8, color: widget.meFgColor),
  //         ),
  //       ),
  //     );

  void _startPlaying() async {
    print(widget.audioSrc);
    if (widget.audioFile != null) {
      String path = (await widget.audioFile!).path;
      debugPrint("> _startPlaying path $path");
      await _player.play(DeviceFileSource(path));
    } else if (widget.audioSrc != null) {
      await _player.play(UrlSource(widget.audioSrc!));
    }
    _controller!.forward();
  }

  _stopPlaying() async {
    await _player.pause();
    _controller!.stop();
  }

  void _setDuration() async {
    if (widget.duration != null) {
      _audioDuration = widget.duration;
    } else {
      _audioDuration = await jsAudio.AudioPlayer().setUrl(widget.audioSrc!);
    }
    duration = _audioDuration!.inMilliseconds;
    maxDurationForSlider = duration + .0;

    ///
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: noiseWidth,
      duration: _audioDuration,
    );

    ///
    _controller!.addListener(() {
      if (_controller!.isCompleted) {
        _controller!.reset();
        _isPlaying = false;
        x2 = false;
        setState(() {});
      }
    });
    _setAnimationConfiguration(_audioDuration!);
  }

  void _setAnimationConfiguration(Duration audioDuration) async {
    setState(() {
      time = widget.formatDuration!(audioDuration);
    });

    _completeAnimationConfiguration();
  }

  void _completeAnimationConfiguration() =>
      setState(() => _audioConfigurationDone = true);

  // void _toggle2x() {
  //   x2 = !x2;
  //   _controller!.duration = Duration(seconds: x2 ? duration ~/ 2 : duration);
  //   if (_controller!.isAnimating) _controller!.forward();
  //   _player.setPlaybackRate(x2 ? 2 : 1);
  //   setState(() {});
  // }

  void _changePlayingStatus() async {
    if (widget.onPlay != null) widget.onPlay!();
    _isPlaying ? _stopPlaying() : _startPlaying();
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    stream.cancel();
    _player.dispose();
    _controller?.dispose();
    super.dispose();
  }

  ///
  _onChangeSlider(double d) async {
    if (_isPlaying) _changePlayingStatus();
    duration = d.round();
    _controller?.value = (noiseWidth) * duration / maxDurationForSlider;
    time = widget.formatDuration!(_audioDuration!);
    await _player.seek(Duration(milliseconds: duration));
    setState(() {});
  }
}

///
class CustomTrackShape extends RoundedRectSliderTrackShape {
  ///
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 10;
    final double trackLeft = offset.dx,
        trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
