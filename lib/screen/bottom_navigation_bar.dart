import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/screen/chat/chat_screen.dart';
import '../widget/message_badge.dart';
import 'home/home_view.dart';
import 'profile/current_user_profile.dart';

final scrollController = ScrollController();

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int i = 1;
  @override
  Widget build(BuildContext context) => Consumer(builder: (context, ref, _) {
        return Scaffold(
          body: [
            const HomeView(),
            const ChatScreen(),
            const CurrentUserProfile()
          ][i],
          bottomNavigationBar: NavigationBar(
              onDestinationSelected: (val) => setState(() => i = val),
              selectedIndex: i,
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_filled), label: 'Home'),
                NavigationDestination(icon: MessageBadge(), label: 'Chats'),
                NavigationDestination(
                    icon: Icon(Icons.person), label: 'Profile'),
              ]),
        );
      });
}
