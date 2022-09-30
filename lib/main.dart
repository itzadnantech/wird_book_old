import 'package:flutter/material.dart';
import 'package:wird_book/localization/demo_localization.dart';
import 'package:wird_book/pages/athkars_page.dart';
import 'package:wird_book/pages/setting_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'localization/language_constants.dart';
import 'package:wird_book/config.dart' as config;
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FontSizeController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Color(config.colorPrimary))),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Wird Book App",
        theme: ThemeData(
          primaryColor: Color(config.colorPrimary),
        ),
        locale: _locale,
        supportedLocales: [
          Locale("en", "US"),
          Locale("ar", "SA"),
        ],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        // onGenerateRoute: CustomRouter.generatedRoute,
        // initialRoute: homeRoute,
        home: AthkarsPage(),
      );
    }
  }
}
