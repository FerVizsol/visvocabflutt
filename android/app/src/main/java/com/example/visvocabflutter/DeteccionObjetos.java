package com.example.visvocabflutter;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.widget.Toast;
import org.tensorflow.lite.Interpreter;
import org.yaml.snakeyaml.Yaml;
import android.content.Context;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DeteccionObjetos {

    private static final int REQUEST_IMAGE_CAPTURE = 1;
    final int imgDimensiones = 320;

    public String processImage(Bitmap imageBitmap, Context context) {
        try {
            Interpreter.Options options = new Interpreter.Options();
            options.setNumThreads(4); // Adjust according to your device's capabilities
            InputStream inputStream = context.getAssets().open("best_float32.tflite");
            int size = inputStream.available();
            byte[] buffer = new byte[size];
            inputStream.read(buffer);
            inputStream.close();
            ByteBuffer modelBuffer = ByteBuffer.allocateDirect(size);
            modelBuffer.order(ByteOrder.nativeOrder());
            modelBuffer.put(buffer);
            modelBuffer.rewind();

            Interpreter interpreter = new Interpreter(modelBuffer, options);
            // Define input and output tensors
            int inputImageWidth = 320;
            int inputImageHeight = 320;
            int channels = 3;
            int batchSize = 1;
            int outputSize = 1000;

            int[] inputShape = {batchSize, inputImageWidth, inputImageHeight, channels};
            int[] outputShape = {batchSize, outputSize};

            // Allocate buffers for input and output
            ByteBuffer inputBuffer = ByteBuffer.allocateDirect(batchSize * inputImageWidth * inputImageHeight * channels * Float.SIZE / 8);
            inputBuffer.order(ByteOrder.nativeOrder());

            ByteBuffer outputBuffer = ByteBuffer.allocateDirect(batchSize * outputSize * Float.SIZE / 8);
            outputBuffer.order(ByteOrder.nativeOrder());

            // Preprocess the input image
            Bitmap resizedImage = Bitmap.createScaledBitmap(imageBitmap, inputImageWidth, inputImageHeight, false);
            preprocessInputImage(resizedImage, inputBuffer);

            // Run inference
            interpreter.run(inputBuffer, outputBuffer);

            // Post-process the inference results
            return postprocessOutput(outputBuffer, context);

        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    private void preprocessInputImage(Bitmap image, ByteBuffer inputBuffer) {
        // Convert Bitmap to ByteBuffer
        int[] intValues = new int[image.getWidth() * image.getHeight()];
        inputBuffer.rewind();
        image.getPixels(intValues, 0, image.getWidth(), 0, 0, image.getWidth(), image.getHeight());
        int pixel = 0;
        for (int i = 0; i < image.getWidth(); ++i) {
            for (int j = 0; j < image.getHeight(); ++j) {
                final int val = intValues[pixel++];
                inputBuffer.putFloat(((val >> 16) & 0xFF) / 255.0f);
                inputBuffer.putFloat(((val >> 8) & 0xFF) / 255.0f);
                inputBuffer.putFloat((val & 0xFF) / 255.0f);
            }
        }
    }

    private String postprocessOutput(ByteBuffer outputBuffer, Context context) {
        // Process the output buffer to get the index of the class with the highest probability
        outputBuffer.rewind();
        float[] outputValues = new float[outputBuffer.remaining() / 4]; // Assuming each value is a float (4 bytes)

        // Fill the outputValues array with values from the outputBuffer
        outputBuffer.asFloatBuffer().get(outputValues);

        // Find the index of the class with the highest probability
        int maxIndex = -1;
        float maxProbability = Float.NEGATIVE_INFINITY;
        for (int i = 0; i < outputValues.length; i++) {
            if (outputValues[i] > maxProbability) {
                maxProbability = outputValues[i];
                maxIndex = i;
            }
        }
        try {
            InputStream inputStream = context.getAssets().open("metadata.yaml");
            Yaml yaml = new Yaml();
            Map<String, Object> metadata = yaml.load(inputStream);
            Map<String, Object> namesMap = (Map<String, Object>) metadata.get("names");
            Log.d("NamesMap", namesMap.toString());
            List<String> labels = new ArrayList<>();
            for (Object value : namesMap.values()) {
                labels.add((String) value);
            }
            String label = labels.get(maxIndex);
            Log.d("Result", "Detected object: " + label);
            Toast.makeText(context, label, Toast.LENGTH_SHORT).show();
            return "Result: " + label;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // Now, maxIndex contains the index of the class with the highest probability
        // You can use this index to retrieve class labels or perform further processing
    }
}
