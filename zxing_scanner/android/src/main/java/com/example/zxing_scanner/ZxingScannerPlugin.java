package com.example.zxing_scanner;


import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.example.zxing_scanner.activity.CodeUtils;
import com.example.zxing_scanner.activity.ZXingLibrary;

import java.io.ByteArrayOutputStream;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.example.zxing_scanner.activity.CodeUtils.RESULT_SUCCESS;
import static com.example.zxing_scanner.activity.CodeUtils.RESULT_TYPE;

/**
 * ZxingScannerPlugin
 */
public class ZxingScannerPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private MethodChannel channel;
    private final static String TAG = "ZxingScanner";
    private Result result = null;
    private Activity activity;
    private final int REQUEST_CODE = 100;
    private final int REQUEST_IMAGE = 101;

//    public ZxingScannerPlugin() {
//    }
//
//    private ZxingScannerPlugin(FlutterActivity activity, final PluginRegistry.Registrar registrar) {
//        ZxingScannerPlugin.activity = activity;
//    }
//
//    public static void registerWith(final PluginRegistry.Registrar registrar) {
//        if (registrar.activity() == null) {
//            return;
//        }
//        Activity activity = registrar.activity();
//        Application applicationContext = null;
//        if (registrar.context() != null) {
//            applicationContext = (Application) (registrar.context().getApplicationContext());
//        }
//        ZxingScannerPlugin instance = new ZxingScannerPlugin((FlutterActivity) registrar.activity(), registrar);
//        instance.createPluginSetup(registrar.messenger(), applicationContext, activity, registrar, null);
//    }

    public static void registerWith(Registrar registrar) {
        ZxingScannerPlugin plugin = new ZxingScannerPlugin();
        plugin.activity = registrar.activity();
        plugin.channel = new MethodChannel(registrar.messenger(), "zxing_scan");
        plugin.channel.setMethodCallHandler(plugin);
        registrar.addActivityResultListener(plugin);

        ZXingLibrary.initDisplayOpinion(registrar.activity());
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.i(TAG, "onAttachedToEngine: ");
        channel = new MethodChannel(binding.getBinaryMessenger(), "zxing_scan");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        Log.i(TAG, "onDetacahedFromEngine: ");
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

        Log.i(TAG, "onAttachedToActivity: ");
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
        ZXingLibrary.initDisplayOpinion(activity);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        Log.i(TAG, "onDetachedFromActivity: ");
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
        Log.i(TAG, "onDetachedFromActivityForConfigChanges");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.i(TAG, "OnReattachedToActivityForConfigChanges");
        onAttachedToActivity(binding);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        Log.i(TAG, "onMethodCall: " + call.method);
        switch (call.method) {
            case "scan":
                Log.i(TAG, "scan");
                this.result = result;
                showBarCodeView();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void showBarCodeView() {
        Intent intent = new Intent(activity, CaptureActivity.class);
        activity.startActivityForResult(intent, REQUEST_CODE);
    }

    @Override
    public boolean onActivityResult(int code, int resultCode, Intent intent) {
        if (code == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && intent != null) {
                Bundle secondBundle = intent.getBundleExtra("secondBundle");
                if (secondBundle != null) {
                    try {
                        CodeUtils.AnalyzeCallback analyzeCallback = new CustomAnalyzeCallback(this.result, intent);
                        CodeUtils.analyzeBitmap(secondBundle.getString("path"),analyzeCallback);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    Bundle bundle = intent.getExtras();
                    if (bundle != null) {
                        if (bundle.getInt(RESULT_TYPE) == RESULT_SUCCESS) {
                            String barcode = bundle.getString(CodeUtils.RESULT_STRING);
                            this.result.success(barcode);
                        } else {
                            this.result.success(null);
                        }
                    }
                }
            } else {
                String errorCode = intent != null ? intent.getStringExtra("ERROR_CODE") : null;
                if (errorCode != null) {
                    this.result.error(errorCode, null, null);
                }
            }
            return true;
        }
        return false;
    }

}
