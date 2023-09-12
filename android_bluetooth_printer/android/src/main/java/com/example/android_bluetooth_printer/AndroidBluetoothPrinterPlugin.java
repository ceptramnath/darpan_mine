package com.example.android_bluetooth_printer;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.dantsu.escposprinter.EscPosPrinter;
import com.dantsu.escposprinter.connection.bluetooth.BluetoothConnection;
import com.dantsu.escposprinter.connection.bluetooth.BluetoothPrintersConnections;
import com.dantsu.escposprinter.connection.usb.UsbConnection;
import com.dantsu.escposprinter.connection.usb.UsbPrintersConnections;
import com.dantsu.escposprinter.exceptions.EscPosBarcodeException;
import com.dantsu.escposprinter.exceptions.EscPosConnectionException;
import com.dantsu.escposprinter.exceptions.EscPosEncodingException;
import com.dantsu.escposprinter.exceptions.EscPosParserException;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/** AndroidBluetoothPrinterPlugin */
public class AndroidBluetoothPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EscPosPrinter printer;
  private BluetoothConnection[] bluetoothPrinters;
  private UsbConnection[] USBPrinters;
  private Context context;
  String printText;
  BluetoothPrintersConnections printers;
  private BluetoothConnection selectedDevice;
  private UsbPrintersConnections USbprinters;
  private PendingIntent mPermissionIndent;

  String deviceId;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "android_bluetooth_printer");
    channel.setMethodCallHandler(this);
    context=flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("print")) {
      printText=call.argument("text");
      if (printText == null || printText.isEmpty()) {
        result.error(
                "400",
                "Please supply this print method with a text to print",
                null
                );
      }
      else {
        try {
//          printBluetooth();
          print(printText);
          result.success("printed");
        } catch(Exception e){
          e.printStackTrace();
        }
      }
    }
    else if(call.method.equals("USBPrint")){
      String printText=call.argument("text");
      deviceId=call.argument("b");

      if (printText == null || printText.isEmpty()) {
        result.error(
                "400",
                "Please supply this print method with a text to print",
                null
                );
      } else {
        USBprint(printText);
        result.success("printed");
      }
    }
    else {
      result.notImplemented();
    }
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  BluetoothConnection getPrinter(String printerAddress){
    System.out.println(printerAddress);
    System.out.println("came to fetch printer");
    try {
      printers = new BluetoothPrintersConnections();
    }
    catch (Exception e){
      System.out.println(e);
    }
    System.out.println(printers.getList());
    System.out.println(printers.getList().length);
    bluetoothPrinters=printers.getList();
    System.out.print(bluetoothPrinters.length);
    if(printerAddress!=null){

     BluetoothConnection lastPrinter=BluetoothPrintersConnections.selectFirstPaired();
     System.out.println("Printer selected");
     System.out.println(lastPrinter.getDevice());

     if(lastPrinter!=null){
       setLastPrinterAddress(lastPrinter.getDevice().getAddress());
       try {

         return lastPrinter.connect();
       }catch (Exception e){
         e.printStackTrace();
       }
     }
    }

     if(bluetoothPrinters!=null && bluetoothPrinters.length>0){
       try {
         bluetoothPrinters[0].connect();
         setLastPrinterAddress(bluetoothPrinters[0].getDevice().getAddress());
         return bluetoothPrinters[0];
       }catch (Exception e){
         e.printStackTrace();
       }
     }



    return null;
  }


String getUSBPrinterAddress(){
    return context.getSharedPreferences("com.android.example.USB_PERMISSION",Context.MODE_PRIVATE).getString("LAST_USB_ADDRESS",null);
}

private void setUSBPrinterAddress(String address){
  context.getSharedPreferences("com.android.example.USB_PERMISSION", Context.MODE_PRIVATE)
          .edit()
          .putString("LAST_PRINTER_ADDRESS", address)
          .apply();
}

    private void setLastPrinterAddress(String address){
      System.out.println("came to set printer address");
      context.getSharedPreferences("android_bluetooth_print_settings", Context.MODE_PRIVATE)
              .edit()
              .putString("LAST_PRINTER_ADDRESS", address)
              .apply();
  }

  String getLastPrinterAddress(){
    System.out.println("came to fetch printer address");
    return context.getSharedPreferences("android_bluetooth_print_settings", android.content.Context.MODE_PRIVATE).getString(
            "LAST_PRINTER_ADDRESS",
            null
    );
  }

  void print(String text) throws EscPosConnectionException, EscPosParserException, EscPosEncodingException, EscPosBarcodeException {

    System.out.println("Received Text for Printing");
    System.out.println(text);
    try {
      printer = new EscPosPrinter(getPrinter(getLastPrinterAddress()),
              203,
              58f,
              32);
      printer.printFormattedText(text);
    }

     catch (Exception e){
       e.printStackTrace();
     }

    printer.disconnectPrinter();
  }

  void USBprint(String text)  {

    System.out.println("Received Text for Printing");
    System.out.println("text received is:");
    System.out.println(text);
//    requestPermission();

  try {
    printer = new EscPosPrinter(getUSBPrinter(getUSBPrinterAddress()),
            203,
            58f,
            32);
    System.out.println("text1 received is:");
    System.out.println(text);
    printer.printFormattedText(text);
  } catch (Exception e) {
    e.printStackTrace();
  }

  printer.disconnectPrinter();
}


  UsbConnection getUSBPrinter(String address){
    try {
      USbprinters =new UsbPrintersConnections(context);
    }catch (Exception e){
      e.printStackTrace();
    }

    USBPrinters =USbprinters.getList();
    if(address!=null){
//      UsbConnection lastusbprinter=UsbPrintersConnections.selectFirstConnected(context);
      UsbConnection lastusbprinter=UsbPrintersConnections.selectPrinter(deviceId,context);
      if(lastusbprinter!=null){
        setUSBPrinterAddress(lastusbprinter.getDevice().getDeviceName());
        try {

          return lastusbprinter.connect();
        }catch (Exception e){
          e.printStackTrace();
        }
      }
    }


    if(USBPrinters!=null && USBPrinters.length>0){
      try {
        USBPrinters[0].connect();
        setUSBPrinterAddress(USBPrinters[0].getDevice().getDeviceName());
        return USBPrinters[0];
      }catch (Exception e){
        e.printStackTrace();
      }
    }

    return null;
  }
}
