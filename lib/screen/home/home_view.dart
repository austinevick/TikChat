import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/controller/post_controller.dart';
import '../../controller/auth_view_controller.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/drawer_widget.dart';
import '../../widget/video_player_widget.dart';
import 'post_items.dart';

final postsStreamProvider =
    StreamProvider((ref) => ref.read(postController).getPosts());

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AuthViewController().updateUserPresence(true);
    } else {
      AuthViewController().updateUserPresence(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(postController);

      return Scaffold(
          key: scaffoldKey,
          drawer: const DrawerWidget(),
          body: Stack(
            children: [
              ref.watch(postsStreamProvider).when(
                  data: (data) => PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (ctx, i) {
                        return Stack(
                          children: [
                            // VideoPlayerWidget(url: data[i].videoUrl),
                            SafeArea(
                              minimum:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  const Spacer(),
                                  PostItems(
                                      post: data[i], postNotifier: notifier),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  error: (e, t) => Center(
                        child: Text(e.toString()),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
              const CustomAppBar()
            ],
          ));
    });
  }
}
