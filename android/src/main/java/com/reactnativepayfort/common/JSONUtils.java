package com.reactnativepayfort.common;
import  com.google.gson.annotations.SerializedName;
import com.google.gson.annotations.Expose;

public class JSONUtils {
  @SerializedName("command")
  @Expose
  private String command;
  @SerializedName("merchant_reference")
  @Expose
  private String merchentReference;
  @SerializedName("payment_option")
  @Expose
  private String paymentOption;
  @SerializedName("eci")
  @Expose
  private String eci;
  @SerializedName("order_description")
  @Expose
  private String orderDescription;
  @SerializedName("customer_ip")
  @Expose
  private String customerIp;
  @SerializedName("customer_name")
  @Expose
  private String customerName;
  @SerializedName("phone_number")
  @Expose
  private String phoneNumber;
  @SerializedName("settlement_reference")
  @Expose
  private String settlementReference;
  @SerializedName("merchant_extra")
  @Expose
  private String merchantExtra;
  @SerializedName("access_code")
  @Expose
  private String accessCode;
  @SerializedName("merchant_identifier")
  @Expose
  private String merchantIdentifier;
  @SerializedName("sha_request_phrase")
  @Expose
  private String shaRequestPhrase;
  @SerializedName("amount")
  @Expose
  private Integer amount;
  @SerializedName("currencyType")
  @Expose
  private String currencyType;
  @SerializedName("language")
  @Expose
  private String language;
  @SerializedName("email")
  @Expose
  private String email;
  @SerializedName("isProduction")
  @Expose
  private Boolean isProduction;
  @SerializedName("token_name")
  @Expose
  private String tokenName;
  @SerializedName("sdk_token")
  @Expose
  private String sdkToken;

  public String getCommand() {
    return command;
  }

  public void setCurrencyType(String currencyType) {
    this.currencyType = currencyType;
  }

  public String getLanguage() {
    return language;
  }

  public void setLanguage(String language) {
    this.language = language;
  }

  public String getEmail() {
    return email;
  }

  public void setCommand(String command) {
    this.command = command;
  }
  public String getMerchentReference() {
    return merchentReference;
  }

  public void setMerchentReference(String merchentReference) {
    this.merchentReference = merchentReference;
  }

  public String getPaymentOption() {
    return paymentOption;
  }

  public void setPaymentOption(String paymentOption) {
    this.paymentOption = paymentOption;
  }

  public String getEci() {
    return eci;
  }

  public void setEci(String eci) {
    this.eci = eci;
  }

  public String getOrderDescription() {
    return orderDescription;
  }

  public void setOrderDescription(String orderDescription) {
    this.orderDescription = orderDescription;
  }

  public String getCustomerIp() {
    return customerIp;
  }

  public void setCustomerIp(String customerIp) {
    this.customerIp = customerIp;
  }

  public String getCustomerName() {
    return customerName;
  }

  public void setCustomerName(String customerName) {
    this.customerName = customerName;
  }

  public String getPhoneNumber() {
    return phoneNumber;
  }

  public void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  public String getSettlementReference() {
    return settlementReference;
  }

  public void setSettlementReference(String settlementReference) {
    this.settlementReference = settlementReference;
  }

  public String getMerchantExtra() {
    return merchantExtra;
  }

  public void setMerchantExtra(String merchantExtra) {
    this.merchantExtra = merchantExtra;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public Boolean getProduction() {
    return isProduction;
  }

  public void setIsProduction(Boolean testing) {
    this.isProduction = isProduction;
  }

  public String getTokenName() {
    return tokenName;
  }

  public void setTokenName(String  testing) {
    this.tokenName = tokenName;
  }

  public  String getSDKToken(){
    return  sdkToken;
  }

  public void setSDKToken(String  sdkToken) {
    this.sdkToken = sdkToken;
  }

  public String getAccessCode() {
    return accessCode;
  }

  public void setAccessCode(String accessCode) {
    this.accessCode = accessCode;
  }

  public String getMerchantIdentifier() {
    return merchantIdentifier;
  }

  public void setMerchantIdentifier(String merchantIdentifier) {
    this.merchantIdentifier = merchantIdentifier;
  }

  public String getShaRequestPhrase() {
    return shaRequestPhrase;
  }

  public void setShaRequestPhrase(String shaRequestPhrase) {
    this.shaRequestPhrase = shaRequestPhrase;
  }

  public Integer getAmount() {
    return amount;
  }

  public void setAmount(Integer amount) {
    this.amount = amount;
  }

  public String getCurrencyType() {
    return currencyType;
  }

}
