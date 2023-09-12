package com.example.zxing_scanner;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;

import android.hardware.Sensor;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import com.example.zxing_scanner.activity.CaptureFragment;
import com.example.zxing_scanner.activity.CodeUtils;
import android.widget.Toast;


public class CaptureActivity extends AppCompatActivity {

    private static final String TAG=CaptureActivity.class.getSimpleName();


    public static boolean isLightOpen = false;
    private int REQUEST_IMAGE = 101;
    private LinearLayout lightLayout;
    private LinearLayout backLayout;
    private LinearLayout photoLayout;
    private SensorManager sensorManager;
    private Sensor lightSensor;
    private SensorEventListener sensorEventListener;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_second);
        CaptureFragment captureFragment = new CaptureFragment();
        CodeUtils.setFragmentArgs(captureFragment, R.layout.my_camera);
        captureFragment.setAnalyzeCallback(analyzeCallback);
        getSupportFragmentManager().beginTransaction().replace(R.id.fl_my_container, captureFragment).commit();

        lightLayout = findViewById(R.id.scan_light);
        backLayout = findViewById(R.id.scan_back);
        photoLayout = findViewById(R.id.choose_photo);

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
        sensorEventListener = new EventListener(lightLayout);
        photoLayout.setVisibility(View.INVISIBLE);

        initView();
    }

    @Override
    protected void onResume(){
        super.onResume();
        if(lightSensor!=null){
            sensorManager.registerListener(sensorEventListener,lightSensor,SensorManager.SENSOR_DELAY_NORMAL);

        }
    }

    @Override
    protected void onPause(){
        sensorManager.unregisterListener(sensorEventListener);
        super.onPause();
    }


    private void initView(){
        lightLayout.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v){
                if(!isLightOpen){
                    try{
                        CodeUtils.isLightEnable(true);
                        isLightOpen=true;
                    }catch (Exception e){
                        Toast.makeText(getApplicationContext(),"Cant use light", Toast.LENGTH_SHORT).show();
                    }
                }
                else{
                    try{
                        CodeUtils.isLightEnable(false);
                        isLightOpen=false;
                    }catch (Exception e){
                        Toast.makeText(getApplicationContext(),"Cant use light", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });
        backLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CaptureActivity.this.finish();
            }
        });

    }

    @Override
    public void onBackPressed(){
        Intent resultIntent=new Intent();
        Bundle bundle=new Bundle();
        bundle.putInt(CodeUtils.RESULT_TYPE,CodeUtils.RESULT_FAILED);
        resultIntent.putExtras(bundle);
        CaptureActivity.this.setResult(RESULT_OK,resultIntent);
        CaptureActivity.this.finish();

    }

    private CodeUtils.AnalyzeCallback analyzeCallback = new CodeUtils.AnalyzeCallback() {
        @Override
        public void onAnalyzeSuccess(Bitmap mBitmap, String result) {
            Intent resultIntent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putInt(CodeUtils.RESULT_TYPE, CodeUtils.RESULT_SUCCESS);
            bundle.putString(CodeUtils.RESULT_STRING, result);
            resultIntent.putExtras(bundle);
            CaptureActivity.this.setResult(RESULT_OK, resultIntent);
            CaptureActivity.this.finish();
        }

        @Override
        public void onAnalyzeFailed() {
            Intent resultIntent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putInt(CodeUtils.RESULT_TYPE, CodeUtils.RESULT_FAILED);
            bundle.putString(CodeUtils.RESULT_STRING, "");
            resultIntent.putExtras(bundle);
            CaptureActivity.this.setResult(RESULT_OK, resultIntent);
            CaptureActivity.this.finish();
        }
    };


}

