// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/data/all_wirds.dart';
import 'package:wird_book/model/wird.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wird_book/pages/setting_page.dart';

import 'package:wird_book/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class AllWirdsPage extends StatefulWidget {
  final String wird_cat_id;
  final String wird_sub_cat_id;
  final String wird_sub_cat_title;
  final String wird_audio_link;
  const AllWirdsPage(this.wird_cat_id, this.wird_sub_cat_id,
      this.wird_sub_cat_title, this.wird_audio_link);

  @override
  _AllWirdsPageState createState() => _AllWirdsPageState();
}

class _AllWirdsPageState extends State<AllWirdsPage> {
  List<Wird> wirds;

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  AudioPlayer _audioPlayer;
  double _value = config.fontSize_min;
  double _prevScale = config.prevScale;
  double _scale = config.scale;
  final controller = SwiperController();

  @override
  void initState() {
    super.initState();
    fontSize();
    _scale = config.scale;
    _prevScale = config.prevScale;
    _init();
    wirds = all_wirds
        .where((medium) =>
            medium.wird_sub_cat_id == widget.wird_sub_cat_id &&
            medium.wird_cat_id == widget.wird_cat_id)
        .toList();
    ;
  }

  void init_fontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getDouble('value') ?? config.fontSize_min;
      _value = _value * _scale;
      if (_value > config.fontSize_max) {
        _value = config.fontSize_max;
      }

      if (_value < config.fontSize_min) {
        _value = config.fontSize_min;
      }

      // prefs.setDouble('value', _value);
    });
  }

  double fontSize() {
    init_fontSize();
    return _value;
  }

  void _init() async {
    _audioPlayer = AudioPlayer();

    await _audioPlayer.setUrl(widget.wird_audio_link);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = (_prevScale * (details.scale));
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() {
          _prevScale = _scale;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(config.colorPrimary),
          centerTitle: true,
          title: Text(getTranslated(context,
              "wird_sub_cat_id_${widget.wird_cat_id}_${widget.wird_sub_cat_id}")),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingPage()));
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
          child: Column(
            children: [
              Flexible(
                flex: 16,
                child: Swiper(
                  loop: false,
                  controller: SwiperController(),
                  control: const SwiperControl(
                      iconNext: Icons.arrow_forward_rounded,
                      iconPrevious: Icons.arrow_back_rounded,
                      padding: EdgeInsets.only(left: 40, right: 40, top: 475)),
                  itemBuilder: (BuildContext context, int index) {
                    final single_wird = wirds[index];

                    String wird_translate =
                        "wird_id_${single_wird.wird_cat_id}_${single_wird.wird_sub_cat_id}_${single_wird.wird_id}";
                    String wird_count =
                        '${getTranslated(context, 'wird')}  ${getTranslated(context, single_wird.wird_id)}';
                    String Repetition =
                        '${getTranslated(context, 'repetition')}  ${getTranslated(context, single_wird.repetition)}';
                    return _buildListItem(single_wird, wird_translate,
                        Repetition, wird_count, wirds.length, context);
                  },
                  itemCount: wirds.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Wird single_wird, wird_translate, Repetition,
      wird_count, total_wird, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: <Widget>[
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 0, right: 0, bottom: 10),
                  child: FAProgressBar(
                    currentValue: double.parse(single_wird.wird_id),
                    size: 8,
                    maxValue: double.parse(total_wird.toString()),
                    // changeColorValue: 100,
                    // changeProgressColor: Colors.pink,
                    backgroundColor: Color.fromARGB(255, 169, 170, 179),
                    progressColor: Color(config.colorPrimary),
                    animatedDuration: const Duration(milliseconds: 0),
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    // displayText: '',
                    // formatValueFixed: 0,
                  ),
                )),
            Divider(
              color: Color(config.colorPrimary),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 0, right: 0, bottom: 0),
                  child: ValueListenableBuilder<ProgressBarState>(
                    valueListenable: progressNotifier,
                    builder: (_, value, __) {
                      return ProgressBar(
                        progress: value.current,
                        buffered: value.buffered,
                        total: value.total,
                        onSeek: seek,
                        baseBarColor: const Color.fromARGB(255, 169, 170, 179),
                        progressBarColor: Color(config.colorPrimary),
                        thumbColor: Color(config.colorPrimary),
                        thumbGlowRadius: 5,
                        thumbRadius: 5,
                      );
                    },
                  ),
                )),
            const SizedBox(height: 15),
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 0, left: 5, right: 5, bottom: 0),
                  child: ValueListenableBuilder<ButtonState>(
                    valueListenable: buttonNotifier,
                    // ignore: missing_return
                    builder: (_, value, __) {
                      switch (value) {
                        case ButtonState.loading:
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              color: Color(config.colorPrimary),
                            ),
                          );
                        case ButtonState.paused:
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            padding: const EdgeInsets.all(2),
                            iconSize: 32.0,
                            onPressed: play,
                          );
                        case ButtonState.playing:
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            padding: const EdgeInsets.all(2),
                            iconSize: 32.0,
                            onPressed: pause,
                          );
                      }
                    },
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Divider(color: Color(config.colorPrimary)),
            SizedBox(
              height: 320,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                title: Text(
                  getTranslated(context, wird_translate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize(), fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Divider(color: Color(config.colorPrimary)),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Flexible(
                  flex: 2,
                  child: Text(Repetition,
                      style: TextStyle(
                          fontSize: fontSize(), fontWeight: FontWeight.w600))),
            ])
          ],
        ),
      ),
    );
  }
}

class ProgressBarState {
  ProgressBarState({
    this.current,
    this.buffered,
    this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
