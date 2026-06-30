package com.privacyguard.privacy_guard;

import android.app.Activity;
import android.view.WindowManager;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.HashMap;
import java.util.Map;

public class PrivacyGuardPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private MethodChannel methodChannel;
    private EventChannel screenshotEventChannel;
    private EventChannel recordingEventChannel;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), "privacy_guard/android");
        methodChannel.setMethodCallHandler(this);

        screenshotEventChannel = new EventChannel(
                binding.getBinaryMessenger(),
                "privacy_guard/android/screenshot"
        );
        recordingEventChannel = new EventChannel(
                binding.getBinaryMessenger(),
                "privacy_guard/android/recording"
        );
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "initialize": {
                Map<String, Boolean> capabilities = new HashMap<>();
                capabilities.put("screenshotDetection", false);
                capabilities.put("recordingDetection", false);
                result.success(capabilities);
                break;
            }
            case "preventScreenshots": {
                if (activity != null) {
                    activity.runOnUiThread(() ->
                            activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    );
                    result.success(true);
                } else {
                    result.success(false);
                }
                break;
            }
            case "allowScreenshots": {
                if (activity != null) {
                    activity.runOnUiThread(() ->
                            activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    );
                    result.success(true);
                } else {
                    result.success(false);
                }
                break;
            }
            case "blurAppSwitcher": {
                if (activity != null) {
                    activity.runOnUiThread(() ->
                            activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    );
                    result.success(true);
                } else {
                    result.success(false);
                }
                break;
            }
            case "removeAppSwitcherBlur": {
                if (activity != null) {
                    activity.runOnUiThread(() ->
                            activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    );
                    result.success(true);
                } else {
                    result.success(false);
                }
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        screenshotEventChannel = null;
        recordingEventChannel = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}
