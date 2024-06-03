package com.example.visvocabflutter;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.content.Context;
public class MyMethodChannelHandler {
    public static void registerWith(BinaryMessenger messenger, Context context) {
        MethodChannel channel = new MethodChannel(messenger, "com.example.visualvocab/detect");
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("detectObject")) {
                byte[] imageData = (byte[]) call.arguments;
                Bitmap bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.length);
                String detectedObject = detectObject(bitmap, context);
                result.success(detectedObject);
            } else {
                result.notImplemented();
            }
        });
    }

    private static String detectObject(Bitmap bitmap, Context context) {
        // Implement your object detection logic here using the context
        DeteccionObjetos deteccionObjetos = new DeteccionObjetos();
        return deteccionObjetos.processImage(bitmap, context);
    }
}