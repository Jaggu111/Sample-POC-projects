package com.reactnativesample;

import android.content.Context;
import android.provider.Settings;


import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class BrightDiagnosticsNative extends ReactContextBaseJavaModule  {

    private static String vendorID = "";
    private Context mContext;

    BrightDiagnosticsNative(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        vendorID = Settings.Secure.getString(reactContext.getContentResolver(),
                Settings.Secure.ANDROID_ID);
    }

    @ReactMethod
    public void getVendorID(
            Callback successCallback) {
        successCallback.invoke(null, vendorID);
    }

    @ReactMethod
    public void enableSDK() {

    }

    @ReactMethod
    public void collect() {

    }

    @ReactMethod
    public void disableSDK() {

    }

    @Override
    public String getName() {
        return "BrightDiagnosticsNative";
    }

}