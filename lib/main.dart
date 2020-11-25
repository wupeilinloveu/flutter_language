import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_language/generated/l10n.dart';
import 'package:flutter_language/provider/current_locale.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => CurrentLocale())],
    child: MyApp(),
  ));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLocale>(
      builder: (context, currentLocale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            S.delegate
          ],
          locale: currentLocale.value,
          supportedLocales: [
            const Locale('zh', 'CN'),
            const Locale('en', 'US'),
          ],
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).home),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.black12,
          onPressed: () async {
            int i = await showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(S.of(context).settingLanguage),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, 1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(S.of(context).settingLanguageChinese),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, 2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(S.of(context).settingLanguageEnglish),
                        ),
                      ),
                    ],
                  );
                });
            if (i != null) {
              if (i == 1) {
                Provider.of<CurrentLocale>(context, listen: false)
                    .setLocale(const Locale('zh', "CH"));
              } else {
                Provider.of<CurrentLocale>(context, listen: false)
                    .setLocale(const Locale('en', "US"));
              }
            }
          },
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(
                10.0, 20.0, 0.0, 20.0),
            child: new Text(S.of(context).settingLanguage),
          ),
        ),
      ),
    );
  }
}
