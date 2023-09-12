package dop.indiapost.newenc;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import newencrypt.Newencrypt;

/** NewencPlugin */
public class NewencPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "newenc");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    else if (call.method.equals("signString")) {
      String content=call.argument("a");

      String p= Newencrypt.signString(content);
      result.success(p);
    }

    else if (call.method.equals("verifyString")) {

      String s=Newencrypt.verifyString(call.argument("a"),call.argument("b"));
      result.success(s);
    }

    else if (call.method.equals("signFiles")) {
      String content=call.argument("a");

      String p= Newencrypt.signFile(content);
      result.success(p);
    }

    else if (call.method.equals("verifyFiles")) {

      String s=Newencrypt.verifyFile(call.argument("a"),call.argument("b"));
      result.success(s);
    }

    else if (call.method.equals("Test")) {
      String path=call.argument("a");
      String endpoint=call.argument("b");
      String contentid=call.argument("c");
      String p= Newencrypt.getRequestBody(path,endpoint,contentid);
      result.success(p);
    }

    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
