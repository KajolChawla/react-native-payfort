package com.reactnativepayfort.common;

import android.app.Activity;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import static java.lang.Math.random;

public class UtilsPayment {

  public String sha256HashForText(String text) throws NoSuchAlgorithmException {
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] textBytes = new byte[0];
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
      textBytes = text.getBytes(StandardCharsets.UTF_8);
    }
    md.update(textBytes, 0, textBytes.length);
    byte[] sha1hash = md.digest();
    StringBuilder stringBuilder = new StringBuilder();
    for (byte i : sha1hash) {
      int nibble = (i >>> 4) & 0x0F;
      int j = 0;
      do {
        stringBuilder.append((0 <= nibble) && (nibble <= 9) ? (char) ('0' + nibble) : (char) ('a' + (nibble - 10)));
        nibble = i & 0x0F;
      } while (j ++ < 1);
    }
    return stringBuilder.toString();
  }

}
