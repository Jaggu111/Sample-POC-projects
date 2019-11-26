package com.reactnativesample;

import android.content.Context;
import android.provider.Settings;

import com.att.brightdiagnostics.BrightDiagnostics;
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
        BrightDiagnostics.enabled(mContext, true);
    }

    @ReactMethod
    public void collect() {
        BrightDiagnostics.collect();
    }

    @ReactMethod
    public void disableSDK() {
        BrightDiagnostics.enabled(mContext, false);
    }

    @Override
    public String getName() {
        return "BrightDiagnosticsNative";
    }

}