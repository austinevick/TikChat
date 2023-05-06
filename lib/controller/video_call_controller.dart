import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/session_controller.dart';

class VideoCallController {
  static Future<void> toggleCamera(
      {required SessionController sessionController}) async {
    var status = await Permission.camera.status;
    if (sessionController.value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    sessionController.value = sessionController.value.copyWith(
        isLocalVideoDisabled: !(sessionController.value.isLocalVideoDisabled));
    await sessionController.value.engine
        ?.muteLocalVideoStream(sessionController.value.isLocalVideoDisabled);
  }

  static Future<void> endCall(
      {required SessionController sessionController}) async {
    if (sessionController.value.connectionData!.screenSharingEnabled &&
        sessionController.value.isScreenShared) {
      await sessionController.value.engine?.stopScreenCapture();
    }
    await sessionController.value.engine?.stopPreview();
    await sessionController.value.engine?.leaveChannel();
    if (sessionController.value.connectionData!.rtmEnabled) {
      await sessionController.value.agoraRtmChannel?.leave();
      await sessionController.value.agoraRtmClient?.logout();
    }
    await sessionController.value.engine?.release();
  }

  static Future<void> toggleMute(
      {required SessionController sessionController}) async {
    var status = await Permission.microphone.status;
    if (sessionController.value.isLocalUserMuted && status.isDenied) {
      await Permission.microphone.request();
    }
    sessionController.value = sessionController.value.copyWith(
        isLocalUserMuted: !(sessionController.value.isLocalUserMuted));
    await sessionController.value.engine
        ?.muteLocalAudioStream(sessionController.value.isLocalUserMuted);
  }

  static Future<void> switchCamera(
      {required SessionController sessionController}) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    await sessionController.value.engine?.switchCamera();
  }
}
