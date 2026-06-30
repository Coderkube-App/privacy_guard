import Flutter
import UIKit

public class PrivacyGuardPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var screenshotEventChannel: FlutterEventChannel?
    private var recordingEventChannel: FlutterEventChannel?
    private var screenshotEventSink: FlutterEventSink?
    private var recordingEventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "privacy_guard/ios",
            binaryMessenger: registrar.messenger()
        )
        let instance = PrivacyGuardPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)

        instance.screenshotEventChannel = FlutterEventChannel(
            name: "privacy_guard/ios/screenshot",
            binaryMessenger: registrar.messenger()
        )
        instance.screenshotEventChannel?.setStreamHandler(instance)

        instance.recordingEventChannel = FlutterEventChannel(
            name: "privacy_guard/ios/recording",
            binaryMessenger: registrar.messenger()
        )
        instance.recordingEventChannel?.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            let capabilities: [String: Bool] = [
                "screenshotDetection": true,
                "recordingDetection": true
            ]
            setupNotifications()
            result(capabilities)
        case "preventScreenshots":
            result(true)
        case "allowScreenshots":
            result(true)
        case "blurAppSwitcher":
            DispatchQueue.main.async {
                UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
            }
            result(true)
        case "removeAppSwitcherBlur":
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenshot),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenRecordingChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
    }

    @objc private func handleScreenshot() {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let event: [String: Any] = [
            "timestamp": timestamp,
            "platform": "ios"
        ]
        screenshotEventSink?(event)
    }

    @objc private func handleScreenRecordingChange() {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let isCaptured = UIScreen.main.isCaptured
        let event: [String: Any] = [
            "timestamp": timestamp,
            "platform": "ios",
            "isRecording": isCaptured
        ]
        recordingEventSink?(event)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let channelName = arguments as? String {
            if channelName == "screenshot" {
                screenshotEventSink = events
            } else if channelName == "recording" {
                recordingEventSink = events
            }
        } else {
            screenshotEventSink = events
            recordingEventSink = events
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        screenshotEventSink = nil
        recordingEventSink = nil
        return nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
