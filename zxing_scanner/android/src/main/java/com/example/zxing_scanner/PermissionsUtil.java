package com.example.zxing_scanner;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

public final class PermissionsUtil {

    public static void initPermissions(Activity activity){
        String[] permissions=PermissionsUtil.checkPermission(activity);
        if(permissions.length!=0){
            ActivityCompat.requestPermissions(activity,permissions,100);
        }
    }
    private static String[] permissions=new String[]{
            Manifest.permission.CAMERA
    };
    private PermissionsUtil(){}

private static String[] checkPermission(Context context) {
        List<String> data = new ArrayList<>();
        for (String permission : permissions) {
        int checkSelfPermission = ContextCompat.checkSelfPermission(context, permission);
        if (checkSelfPermission == PackageManager.PERMISSION_DENIED) {
        data.add(permission);
        }
        }
        return data.toArray(new String[0]);
        }

}
