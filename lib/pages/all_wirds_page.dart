import 'package:flutter/material.dart';
import 'package:wird_book/classes/language.dart';
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/main.dart';
import 'package:wird_book/pages/all_wird_sub_cat_page.dart';
import 'package:wird_book/data/all_wirds.dart';
import 'package:wird_book/model/wird.dart';
import 'package:just_audio/just_audio.dart';

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

  /// Compulsory
  final player = AudioPlayer();
  String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';

  @override
  void initState() {
    super.initState();
    wirds = all_wirds
        .where((medium) =>
            medium.wird_sub_cat_id == widget.wird_sub_cat_id &&
            medium.wird_cat_id == widget.wird_cat_id)
        .toList();
  }

  /// Compulsory
  playMusic() async {
    final duration = await player.setUrl(widget.wird_audio_link);
    player.play();
  }

  /// Compulsory
  pauseMusic() async {
    await player.pause();
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: playMusic,
                    icon: Icon(Icons.play_arrow),
                    label: Text(getTranslated(context, 'playbtn')),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 6, 20, 97)),
                  ),
                  ElevatedButton.icon(
                    onPressed: pauseMusic,
                    icon: Icon(Icons.stop),
                    label: Text(getTranslated(context, 'stopbtn')),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 6, 20, 97)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              height: MediaQuery.of(context).size.height * 0.8,
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
                    return WirdCards(single_wird, wird_translate, context);
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget WirdCards(Wird single_wird, wird_translate, context) => Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  title: Text(
                    getTranslated(context, "wird_" + single_wird.wird_id),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 6, 20, 97),
                        fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                    getTranslated(context, wird_translate),
                    textAlign: TextAlign.center,
                  ))),
        ),
      );
}
