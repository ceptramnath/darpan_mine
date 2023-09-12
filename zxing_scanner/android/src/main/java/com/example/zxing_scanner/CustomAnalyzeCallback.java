package com.example.zxing_scanner;

import android.graphics.Bitmap;
import android.content.Intent;
import io.flutter.plugin.common.MethodChannel.Result;
import com.example.zxing_scanner.activity.CodeUtils;

public class CustomAnalyzeCallback implements CodeUtils.AnalyzeCallback{
    private Result result;

    private Intent intent;

    public CustomAnalyzeCallback(Result result, Intent intent){
        this.result=result;
        this.intent=intent;
    }

    @Override
    public void onAnalyzeSuccess(Bitmap mBitmap,String result){
        this.result.success(result);
    }

    @Override
    public void onAnalyzeFailed(){
        String errorCode = this.intent.getStringExtra("ERROR_CODE");
        this.result.error(errorCode, null, null);
    }

}
