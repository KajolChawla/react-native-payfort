package com.reactnativepayfort;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ActivityEventListener;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.payfort.fortpaymentsdk.callbacks.FortCallBackManager;
import com.payfort.fortpaymentsdk.callbacks.FortCallback;
import com.payfort.fortpaymentsdk.FortSdk;
import com.facebook.react.bridge.Promise;
import com.payfort.fortpaymentsdk.callbacks.FortInterfaces;
import com.payfort.fortpaymentsdk.domain.model.FortRequest;
import com.reactnativepayfort.common.JSONUtils;
import com.reactnativepayfort.common.UtilsPayment;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import  com.facebook.react.bridge.Callback;

import java.lang.reflect.Type;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import static java.lang.Math.random;

@ReactModule(name = PayfortModule.NAME)
public class PayfortModule extends ReactContextBaseJavaModule implements ActivityEventListener {
    public static final String NAME = "Payfort";
  private static ReactApplicationContext reactContext;
    private FortCallBackManager payFortCallback= FortCallback.Factory.create();
    private UtilsPayment utils = new UtilsPayment();

    @Override
    @NonNull
    public String getName() {
        return "{name: Payfort, author: shubham dhumal}";
    }
    @ReactMethod
    public void getDeviceId(Callback successCallback){
    try{
        successCallback.invoke(FortSdk.getDeviceId(getCurrentActivity()));
      } catch(Exception e){
        System.out.println(e);
      }
    }
    @ReactMethod
    public void getSHA256(String input, Callback successCallback ) throws NoSuchAlgorithmException {
      String hash = utils.sha256HashForText(input);
      successCallback.invoke(hash);
    }
    @ReactMethod
    public void Pay(String strData, Callback successCallback, Callback errorCallback){
      Gson gson=new Gson();
      JSONUtils input = gson.fromJson(strData, JSONUtils.class);
      Map<String, Object> requestMap = new HashMap<>();
      requestMap.put("command", input.getCommand());
      requestMap.put("customer_email", input.getEmail());
      requestMap.put("currency", input.getCurrencyType());
      requestMap.put("amount", input.getAmount());
      requestMap.put("language", input.getLanguage());
      requestMap.put("sdk_token", input.getSDKToken());
      requestMap.put("merchant_reference", input.getMerchentReference());

      if(input.getTokenName()!=null){
        requestMap.put("token_name", input.getTokenName());
      }
      if(input.getPaymentOption()!=null){
        requestMap.put("payment_option", input.getPaymentOption());
      }
      if(input.getEci()!=null){
        requestMap.put("eci", input.getEci());
      }
      if(input.getOrderDescription()!=null){
        requestMap.put("order_description", input.getOrderDescription());
      }
      if(input.getCustomerName()!=null){
        requestMap.put("customer_name", input.getCustomerName());
      }
      if(input.getPhoneNumber()!=null){
        requestMap.put("phone_number", input.getPhoneNumber());
      }
      if(input.getMerchantExtra()!=null){
        requestMap.put("merchant_extra", input.getMerchantExtra());
      }
      
      try{
        FortRequest fortrequest = new FortRequest();
        fortrequest.setRequestMap(requestMap);
        fortrequest.setShowResponsePage(true); // to [display/use]
        FortSdk.getInstance().registerCallback(getCurrentActivity(), fortrequest, input.getProduction() ? FortSdk.ENVIRONMENT.PRODUCTION : FortSdk.ENVIRONMENT.TEST, 2000, payFortCallback, true,
          new FortInterfaces.OnTnxProcessed() {
          @Override
          public void onCancel(Map<String, Object> requestMap, Map<String, Object> responseMap) {
//                            Toast.makeText(reactContext, "Payment cancel by user", Toast.LENGTH_SHORT).show();
//                            Log.d("Hello", "onCancel() called with: map = [" + requestMap + "], map1 = [" + responseMap + "]");
            errorCallback.invoke(converMapToJson(responseMap));
          }
          @Override
          public void onSuccess(Map<String, Object> requestMap, Map<String, Object> responseMap) {
//                            Toast.makeText(reactContext, "Payment Success", Toast.LENGTH_SHORT).show();
                            Log.d("Hello", "onSuccess() called with: map = [" + requestMap + "], map1 = [" + responseMap + "]");
            successCallback.invoke(converMapToJson(responseMap));

          }
          @Override
          public void onFailure(Map<String, Object> requestMap, Map<String, Object> responseMap) {
//                            Toast.makeText(reactContext, "Payment fail", Toast.LENGTH_SHORT).show();
                            Log.d("Hello", "onFailure() called with: map = [" + requestMap + "], map1 = [" + responseMap + "]");
            errorCallback.invoke(converMapToJson(responseMap));
          }
        });
      }
      catch (Exception e){

      }
    }
  @Override
  public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    payFortCallback.onActivityResult(requestCode,resultCode,data);
  }

  @Override
  public void onNewIntent(Intent intent) {

  }
  private String converMapToJson(Map<String, Object> source){
    Gson gson=new Gson();
    Type gsonType = new TypeToken<HashMap>(){}.getType();
    String gsonString = gson.toJson(source,gsonType);
    return gsonString;
  }
  public PayfortModule(@NonNull ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.reactContext.addActivityEventListener(this);
  }
}
