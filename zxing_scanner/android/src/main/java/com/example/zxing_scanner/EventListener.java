package com.example.zxing_scanner;

import com.example.zxing_scanner.CaptureActivity;


import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.view.View;
import android.widget.LinearLayout;



public class EventListener implements SensorEventListener {

    private LinearLayout lightLayout;

    public EventListener(LinearLayout lightLayout) {
        this.lightLayout = lightLayout;
    }


    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_LIGHT) {
            float light_strength = event.values[0];
            if (lightLayout.getVisibility() == View.VISIBLE && light_strength > 300 && !CaptureActivity.isLightOpen) {
                lightLayout.setVisibility(View.INVISIBLE);
            } else if (lightLayout.getVisibility() == View.INVISIBLE && light_strength <= 200) {
                lightLayout.setVisibility(View.VISIBLE);
            }
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
