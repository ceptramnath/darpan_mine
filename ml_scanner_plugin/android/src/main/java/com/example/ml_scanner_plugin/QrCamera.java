package com.example.ml_scanner_plugin;

interface QrCamera {

    void start() throws QrReader.Exception;
    void stop();
    int getOrientation();
    int getWidth();
    int getHeight();

}
