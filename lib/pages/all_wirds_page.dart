import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:wird_book/classes/language.dart';
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/main.dart';
// import 'package:wird_book/page_manager.dart';
import 'package:wird_book/pages/all_wird_sub_cat_page.dart';
import 'package:wird_book/data/all_wirds.dart';
import 'package:wird_book/model/wird.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wird_book/pages/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:wird_book/config/fontSize.dart' as GlobalFont;
import 'package:shared_preferences/shared_preferences.dart';

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
  double _value = GlobalFont.fontSize_min;

  @override
  void initState() {
    super.initState();
    fontSize();
    _init();
    wirds = all_wirds
        .where((medium) =>
            medium.wird_sub_cat_id == widget.wird_sub_cat_id &&
            medium.wird_cat_id == widget.wird_cat_id)
        .toList();
  }

  void init_fontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getDouble('value') ?? GlobalFont.fontSize_min;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 20, 97),
        centerTitle: true,
        title: Text(getTranslated(
            context,
            "wird_sub_cat_id_" +
                widget.wird_cat_id +
                "_" +
                widget.wird_sub_cat_id)),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        child: Column(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, left: 80, right: 80, bottom: 0),
                  child: ValueListenableBuilder<ProgressBarState>(
                    valueListenable: progressNotifier,
                    builder: (_, value, __) {
                      return ProgressBar(
                        progress: value.current,
                        buffered: value.buffered,
                        total: value.total,
                        onSeek: seek,
                        baseBarColor: Color.fromARGB(255, 169, 170, 179),
                        progressBarColor: Color.fromARGB(255, 6, 20, 97),
                        thumbColor: Color.fromARGB(255, 6, 20, 97),
                      );
                    },
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 20),
                  child: ValueListenableBuilder<ButtonState>(
                    valueListenable: buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case ButtonState.loading:
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 20.0,
                            height: 20.0,
                            child: const CircularProgressIndicator(
                              color: Color.fromARGB(255, 6, 20, 97),
                            ),
                          );
                        case ButtonState.paused:
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            padding: EdgeInsets.all(2),
                            iconSize: 32.0,
                            onPressed: play,
                          );
                        case ButtonState.playing:
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            padding: EdgeInsets.all(2),
                            iconSize: 32.0,
                            onPressed: pause,
                          );
                      }
                    },
                  ),
                )),
            Flexible(
                flex: 16,
                child: Container(
                  child: ListView.builder(
                      itemCount: wirds.length,
                      itemBuilder: (context, index) {
                        final single_wird = wirds[index];
                        String wird_translate = "wird_id_" +
                            single_wird.wird_cat_id +
                            "_" +
                            single_wird.wird_sub_cat_id +
                            "_" +
                            single_wird.wird_id;
                        String wird_count = getTranslated(context, 'wird') +
                            '  ' +
                            getTranslated(context, single_wird.wird_id);
                        String Repetition =
                            getTranslated(context, 'repetition') +
                                '  ' +
                                getTranslated(context, single_wird.repetition);
                        return WirdCards(single_wird, wird_translate,
                            Repetition, wird_count, context);
                      }),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget WirdCards(
          Wird single_wird, wird_translate, Repetition, wird_count, context) =>

      // width: MediaQuery.of(context).size.width * 0.8,
      Card(
        color: Colors.white,
        elevation: 10,
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              title: Text(
                getTranslated(context, wird_translate),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize(), fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '\n' + Repetition,
                // wird_count + '\n\n' + Repetition + '\n\n',
                // getTranslated(context, "wird_" + single_wird.wird_id),

                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize(),
                    color: Color.fromARGB(255, 6, 20, 97),
                    fontWeight: FontWeight.w500),
              ),
            )),
      );
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
