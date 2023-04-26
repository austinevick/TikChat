import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/screen/chat/custom_audio_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:vibration/vibration.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'common/utils.dart';
import 'notification_config.dart';
import 'screen/bottom_navigation_bar.dart';
import 'widget/custom_audio_widget.dart';
import 'widget/custom_textfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpOneSignal();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: const Color(0xff292d36),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xff11162a))),
        navigatorKey: navigatorKey,
        home: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isReplying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAudioPlayer(
            path:
                'https://firebasestorage.googleapis.com/v0/b/flutter-media-app.appspot.com/o/videos%2F2023-04-22T23%3A20%3A34.594423?alt=media&token=c22cd26a-04b5-4c82-bc6b-9bf9e8d934a3',
          )
        ],
      )),
    );
  }
}
