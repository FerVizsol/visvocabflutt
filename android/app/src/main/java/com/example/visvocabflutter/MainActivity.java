package com.example.visvocabflutter;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import android.content.Context;
public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MyMethodChannelHandler.registerWith(flutterEngine.getDartExecutor().getBinaryMessenger(), this);
    }
}
