package com.example.ml_scanner_plugin;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.GuardedBy;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.mlkit.vision.barcode.Barcode;
import com.google.mlkit.vision.barcode.BarcodeScanner;
import com.google.mlkit.vision.barcode.BarcodeScannerOptions;
import com.google.mlkit.vision.barcode.BarcodeScanning;
import com.google.mlkit.vision.common.InputImage;

import java.util.List;

 class QrDetector implements OnSuccessListener<List<Barcode>>, OnFailureListener{
    private static final String TAG="QrDetector";
    private final QrReaderCallbacks communicator;
    private final BarcodeScanner detector;

    public interface Frame{
        InputImage toImage();
        void close();
    }
    @GuardedBy("this")
    private Frame latestFrame;

    @GuardedBy("this")
    private Frame processingFrame;

    QrDetector(QrReaderCallbacks communicator,BarcodeScannerOptions options){
        this.communicator=communicator;
        this.detector=BarcodeScanning.getClient(options);
    }
    void detect(Frame frame){
        if(latestFrame!=null)
            latestFrame.close();
        latestFrame = frame;
        if(processingFrame==null){
            processLatest();
        }
    }
    private synchronized void processLatest(){
        if(processingFrame!=null)
            processingFrame.close();
        processingFrame=latestFrame;
        latestFrame=null;
        if(processingFrame!=null){
            processFrame(processingFrame);
        }
    }
    private void processFrame(Frame frame){
        InputImage image;
        try{
            image=frame.toImage();
        }catch (IllegalStateException ex){
            return;
        }
        detector.process(image)
                .addOnSuccessListener(this)
                .addOnFailureListener(this);


    }
    @Override
    public void onSuccess(List<Barcode> firebaseVisionBarcodes){
        for(Barcode barcode : firebaseVisionBarcodes){
            communicator.qrRead(barcode.getRawValue());
        }
        processLatest();
    }
    @Override
    public void onFailure(@NonNull Exception e){
        Log.w(TAG,"Barcode Reading Failure: ",e);
    }



}
