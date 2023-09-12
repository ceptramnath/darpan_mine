package dop.indiapost.age_calculator;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.time.LocalDate;
import java.time.Period;

/** AgeCalculatorPlugin */
public class AgeCalculatorPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "age_calculator");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    else if (call.method.equals("calc")) {
//      System.out.println("Signing at functioncall: "+signing);
      String s=calculateAge(call.argument("a"));
      result.success(s);
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public String calculateAge(String dob){
    LocalDate db = LocalDate.parse(dob);
    LocalDate curDate = LocalDate.now();
    if ((dob != null) && (curDate != null))
    {
      return String.valueOf(Period.between(db, curDate).getYears());
    }
    else
    {
      return "0";
    }
  }
}
