package com.example.visvocabflutter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.provider.MediaStore;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.UiThread;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class DetectionPlugin implements MethodCallHandler, ActivityAware {
    private static final int REQUEST_IMAGE_CAPTURE = 1;

    private Context context;
    private Result pendingResult;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("processImage")) {
            dispatchTakePictureIntent();
            pendingResult = result;
        } else {
            result.notImplemented();
        }
    }

    private void dispatchTakePictureIntent() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(context.getPackageManager()) != null) {
            pendingResult.success("Launching camera...");
            // Assuming "context" is the activity context
            context.startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
        } else {
            pendingResult.error("UNAVAILABLE", "Camera is not available.", null);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == Activity.RESULT_OK) {
            Bitmap imageBitmap = (Bitmap) data.getExtras().get("data");
            if (imageBitmap != null) {
                processImage(imageBitmap);
            } else {
                pendingResult.error("NULL_IMAGE", "Captured image is null.", null);
            }
        } else {
            pendingResult.error("CAPTURE_FAILED", "Failed to capture image.", null);
        }
    }

    private void processImage(Bitmap imageBitmap) {
        // Your image processing code goes here
        // You can use TensorFlow Lite or any other library to process the image
        pendingResult.success("Image processed successfully.");
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // Unused method
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        // Unused method
    }
}
