import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:page_transition/page_transition.dart';

final navigatorKey = GlobalKey<NavigatorState>();

String dateFormatter(DateTime date) => DateFormat('kk:mm').format(date);

void showDialogFlash(String content, {String title = '', VoidCallback? onTap}) {
  navigatorKey.currentContext!.showFlashDialog(
      constraints: const BoxConstraints(maxWidth: 300),
      borderRadius: BorderRadius.circular(25),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      content: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
            onPressed: onTap ?? () => controller.dismiss(),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ));
      });
}

void showToast(String message) {
  toast.Fluttertoast.showToast(
    msg: message,
    toastLength: toast.Toast.LENGTH_SHORT,
    gravity: toast.ToastGravity.BOTTOM,
  );
}

void showBottomFlash({String? title, String? content}) {
  showFlash(
    context: navigatorKey.currentContext!,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        margin: const EdgeInsets.all(10),
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        borderRadius: BorderRadius.circular(8.0),
        forwardAnimationCurve: Curves.easeInCirc,
        backgroundColor: Colors.black,
        reverseAnimationCurve: Curves.easeIn,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: FlashBar(
            title: Text(title ?? ''),
            content: Text(
              content ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => controller.dismiss(),
                  child: const Text('DISMISS')),
            ],
          ),
        ),
      );
    },
  );
}

void animatePage(Widget child) => Navigator.of(navigatorKey.currentContext!)
    .push(PageTransition(child: child, type: PageTransitionType.rightToLeft));

Future<void> push(Widget child) => Navigator.of(navigatorKey.currentContext!)
    .push(MaterialPageRoute(builder: (context) => child));

Future<void> pushReplacement(Widget child) =>
    Navigator.of(navigatorKey.currentContext!)
        .pushReplacement(MaterialPageRoute(builder: (context) => child));

Future<void> pushAndRemoveUntil(Widget child) =>
    Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => child), (c) => false);
