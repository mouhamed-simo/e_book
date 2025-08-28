import 'package:ebook_mvp/utils/app_colors.dart';
import 'package:ebook_mvp/utils/app_text_style.dart';
import 'package:ebook_mvp/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;
  final String title;
  const AudioPlayerScreen({
    super.key,
    required this.audioUrl,
    required this.title,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.audioUrl);

      // مدة الملف
      _player.durationStream.listen((d) {
        if (d != null) {
          setState(() => _duration = d);
        }
      });

      // الوقت الحالي
      _player.positionStream.listen((p) {
        setState(() => _position = p);
      });

      // حالة التشغيل
      _player.playerStateStream.listen((state) {
        setState(() => _isPlaying = state.playing);
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 34),
            _buildIconMusic(context),
            const SizedBox(height: 13),

            Text(
              widget.title,
              style: AppTextStyle.withColor(AppTextStyle.h2, AppColors.accent),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 13),

            Text(
              'Chapter 3 : Finding Balance',
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMeduim,
                AppColors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Slider
            _buildSlider(context),
            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[500],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.skip_previous_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final newPosition = _position - Duration(seconds: 10);
                      _player.seek(
                        newPosition >= Duration.zero
                            ? newPosition
                            : Duration.zero,
                      ); // reset
                    },
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),

                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 27,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[500],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.skip_next_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final newPosition = _position + Duration(seconds: 10);
                      _player.seek(
                        newPosition <= _duration ? newPosition : _duration,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconMusic(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: _isPlaying
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.headphones_outlined,
            size: 100,
            color: _isPlaying ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    final sliderValue = _position.inSeconds.toDouble().clamp(
      0.0,
      _duration.inSeconds.toDouble(),
    );

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        inactiveTrackColor: AppColors.grey.withOpacity(0.3),
        activeTrackColor: Theme.of(context).primaryColor,
        thumbColor: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          Slider(
            value: sliderValue,
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              _player.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الوقت الحالي
                Text(
                  _formatDuration(_position),
                  style: AppTextStyle.withColor(
                    AppTextStyle.bodyMeduim,
                    AppColors.grey,
                  ),
                ),
                // المدة الكاملة
                Text(
                  _formatDuration(_duration),
                  style: AppTextStyle.withColor(
                    AppTextStyle.bodyMeduim,
                    AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
