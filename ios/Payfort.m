#import "Payfort.h"
#include <CommonCrypto/CommonDigest.h>
#import <PassKit/PassKit.h>
#import <UIKit/UIKit.h>

#import  </Users/apple/Desktop/npm/oc/react-native-payfort/example/ios/Pods/PayFortSDK/PayFortSDK.xcframework/ios-arm64/PayFortSDK.framework/Headers/PayFortSDK-Swift.h>

@interface Payfort ()
{
    PayFortController * payFort;
}
@end

@implementation Payfort

RCT_EXPORT_MODULE()
NSString *sdk_token;
NSString *_merchant_reference;
NSDictionary *applePayBody;
RCTResponseSenderBlock successCallbackPayfort;
RCTResponseSenderBlock errorCallbackPayfort;
RCTResponseSenderBlock successCallbackApplePay;
RCTResponseSenderBlock errorCallbackApplePay;

RCT_EXPORT_METHOD(getSHA256:(NSString*)strData
                  successCallback:(RCTResponseSenderBlock)successCallback){
    NSString *hash = [self sha256HashForText:strData];
    successCallback(@[hash]);
}

RCT_EXPORT_METHOD(getDeviceId:(RCTResponseSenderBlock)successCallback){
    payFort = [[PayFortController alloc]initWithEnviroment:PayFortEnviromentSandBox];
    //    NSString *UUID = [[NSUUID UUID] UUIDString];
    successCallback(@[payFort.getUDID]);
}

RCT_EXPORT_METHOD(Pay:(NSString *)strData successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback)
{
    NSDictionary *input = [self stringToObject:strData];
    NSLog(@"sdk_token: %@",strData);
    _merchant_reference = [input objectForKey:@"merchant_reference"];

    sdk_token = [input objectForKey:@"sdk_token"];
    NSLog(@"sdk_token: %@",sdk_token);
    
    successCallbackPayfort = successCallback;
    errorCallbackPayfort = errorCallback;
    
    if (sdk_token != nil) {
        NSLog(@"inputs%@", input);
        [self payWithRequest:input];
        
    }else {
        NSLog(@"sdk_token not found %@",sdk_token);
    }
}

RCT_EXPORT_METHOD(PayWithApplePay:(NSString *)strData successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        applePayBody = [self stringToObject:strData];
        _merchant_reference = [applePayBody objectForKey:@"merchant_reference"];
        
        
        
            [self applePayWithRequest:applePayBody];
        
    });
}

- (void)applePayWithRequest:(NSDictionary *)applePayBody
{
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.supportedNetworks=@[PKPaymentNetworkVisa, PKPaymentNetworkAmex,PKPaymentNetworkMasterCard];
    request.countryCode = [applePayBody objectForKey:@"countryCode"];
    request.currencyCode = [applePayBody objectForKey:@"currencyCode"];
    request.merchantIdentifier = [applePayBody objectForKey:@"merchant_identifier"];
    request.merchantCapabilities = PKMerchantCapability3DS;
    
    NSString *summaryLabel = [applePayBody objectForKey:@"summaryLabel"];
    NSString *amount = [applePayBody objectForKey:@"amount"];
    
    request.paymentSummaryItems = @[
        [PKPaymentSummaryItem summaryItemWithLabel:summaryLabel
                                            amount:[NSDecimalNumber decimalNumberWithString:amount]]
    ];
    PKPaymentAuthorizationViewController *applePayController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
       applePayController.delegate = self;
       dispatch_async([self methodQueue], ^{
           UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
           [rootViewController presentViewController:applePayController animated:NO completion:nil];
       });
}


- (void)payWithRequest:(NSDictionary *)input
{
    
    NSNumber *isProduction = [input objectForKey:@"isProduction"];
    _merchant_reference = [input objectForKey:@"merchant_reference"];
    NSString *language = [input objectForKey:@"language"];
    NSString *token_name = [input objectForKey:@"token_name"];
    payFort = [[PayFortController alloc]initWithEnviroment:[isProduction boolValue] ? PayFortEnviromentProduction : PayFortEnviromentSandBox ];

    NSString *command = [input objectForKey:@"command"];
    NSString *merchant_extra = [input objectForKey:@"merchant_extra"];
    NSString *customer_name = [input objectForKey:@"customer_name"];
    NSString *customer_email = [input objectForKey:@"email"];
    NSString *phone_number = [input objectForKey:@"phone_number"];
    NSString *payment_option = [input objectForKey:@"payment_option"];
    NSString *currency = [input objectForKey:@"currencyType"];
    NSString *amount = [input objectForKey:@"amount"];
    NSString *eci = [input objectForKey:@"eci"];
    NSString *order_description = [input objectForKey:@"order_description"];
    
    NSMutableDictionary *request = [[NSMutableDictionary alloc]init];
    [request setValue:command forKey:@"command"];
    [request setValue:sdk_token forKey:@"sdk_token"];
    [request setValue:token_name forKey:@"token_name"];
    [request setValue:_merchant_reference forKey:@"merchant_reference"];
    [request setValue:merchant_extra forKey:@"merchant_extra"];
    [request setValue:customer_name forKey:@"customer_name"];
    [request setValue:customer_email forKey:@"customer_email"];
    [request setValue:phone_number forKey:@"phone_number"];
    [request setValue:payment_option forKey:@"payment_option"];
    [request setValue:language forKey:@"language"];
    [request setValue:currency forKey:@"currency"];
    [request setValue:amount forKey:@"amount"];
    [request setValue:eci forKey:@"eci"];
    [request setValue:order_description forKey:@"order_description"];

    [payFort setPayFortCustomViewNib:@"CustomPayFortView"];
    
        
        payFort.isShowResponsePage = YES;
        payFort.hideLoading = NO;
        payFort.presentAsDefault  = YES;
    dispatch_async([self methodQueue], ^{
        UIViewController *rootViewController =  (UIViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)rootViewController) pushViewController:payFort animated:NO];
        } else {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:payFort];
            [rootViewController addChildViewController:navigationController];
        }
        NSLog(@"root %@",rootViewController );
        [payFort callPayFortWithRequest:request currentViewController:payFort
                                success:^(NSDictionary *requestDic, NSDictionary *responeDic) { NSLog(@"Success");
            NSLog(@"responeDic=%@",responeDic);
            successCallbackPayfort(@[responeDic]);
        }
                               canceled:^(NSDictionary *requestDic, NSDictionary *responeDic) { NSLog(@"Canceled");
            NSLog(@"responeDic=%@",responeDic);
            errorCallbackPayfort(@[responeDic]);
        }
                                  faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
            NSLog(@"Faild");
            NSLog(@"responeDic=%@",responeDic);
            errorCallbackPayfort(@[responeDic]);
        }];
    });
}
//
//
//



- (NSDictionary *) stringToObject:(NSString *)strData
{
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

- (NSString*)sha256HashForText:(NSString*)text {
    const char* utf8chars = [text UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(utf8chars, (CC_LONG)strlen(utf8chars), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier backgroundTask;
    backgroundTask =
    [application beginBackgroundTaskWithExpirationHandler: ^ {
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid; }];
}


- (NSString *)moduleName {
    return @"Payfort";
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate


-(void)paymentAuthorizationViewController:
(PKPaymentAuthorizationViewController *)controller
                      didAuthorizePayment:(PKPayment *)payment
                               completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    BOOL asyncSuccessful = payment.token.paymentData.length != 0;
    NSLog(@"payment %@", payment.token.paymentData);
//    completion(PKPaymentAuthorizationStatusSuccess);

    if(asyncSuccessful) {
        
        NSString *command = [applePayBody objectForKey:@"command"];
        NSString *merchant_extra = [applePayBody objectForKey:@"merchant_extra"];
        NSString *customer_name = [applePayBody objectForKey:@"customer_name"];
        NSString *customer_email = [applePayBody objectForKey:@"email"];
        NSString *phone_number = [applePayBody objectForKey:@"phone_number"];
        NSString *payment_option = [applePayBody objectForKey:@"payment_option"];
        NSString *amount = [applePayBody objectForKey:@"amount"];
        NSString *eci = [applePayBody objectForKey:@"eci"];
        NSNumber *isProduction = [applePayBody objectForKey:@"isProduction"];
        NSString *token_name = [applePayBody objectForKey:@"token_name"];
        _merchant_reference = [applePayBody objectForKey:@"merchant_reference"];
        NSString *language = [applePayBody objectForKey:@"language"];
        NSString *currency = [applePayBody objectForKey:@"currencyType"];
        NSString *order_description = [applePayBody objectForKey:@"order_description"];
        
         payFort = [[PayFortController alloc]initWithEnviroment:[isProduction boolValue] ? PayFortEnviromentProduction : PayFortEnviromentSandBox ];
        
        NSMutableDictionary *request = [[NSMutableDictionary alloc]init];
        [request setValue:command forKey:@"command"];
        [request setValue:[applePayBody objectForKey:@"sdk_token"] forKey:@"sdk_token"];
        [request setValue:token_name forKey:@"token_name"];
        [request setValue:_merchant_reference forKey:@"merchant_reference"];
        [request setValue:merchant_extra forKey:@"merchant_extra"];
        [request setValue:customer_name forKey:@"customer_name"];
        [request setValue:customer_email forKey:@"customer_email"];
        [request setValue:phone_number forKey:@"phone_number"];
        [request setValue:payment_option forKey:@"payment_option"];
        [request setValue:language forKey:@"language"];
        [request setValue:currency forKey:@"currency"];
        [request setValue:amount forKey:@"amount"];
        [request setValue:eci forKey:@"eci"];
        [request setValue:order_description forKey:@"order_description"];
        [request setValue:command forKey:@"command"];
        [request setValue:@"APPLE_PAY" forKey:@"digital_wallet"];

        NSLog(@"request-applePay%@", request);
        payFort.isShowResponsePage = YES;
        
        UIViewController *nav =  (UIViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;

        [payFort callPayFortForApplePayWithRequest:request
                                   applePayPayment:payment
                             currentViewController:nav
                                           success:^(NSDictionary *requestDic, NSDictionary *responeDic) {
//            isApplePaymentDidPayment = TRUE;
            successCallbackApplePay(@[responeDic]);
            NSLog(@"Sucess ApplePay %@", responeDic);
            completion(PKPaymentAuthorizationStatusSuccess);
        }
                                             faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
//            isApplePaymentDidPayment = TRUE;
            NSLog(@"Error %@", responeDic);
            errorCallbackApplePay(@[responeDic]);
            completion(PKPaymentAuthorizationStatusFailure);
        }];
    } else {
//        isApplePaymentDidPayment = TRUE;
//        errorCallbackApplePay(@[]);
        NSLog(@"Errore");
        completion(PKPaymentAuthorizationStatusFailure);
    }
}


-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
//    if(!isApplePaymentDidPayment)
//    {
//        errorCallbackApplePay(@[applePayBody]);
//    }
    NSLog(@"PKPaymentAuthorizationViewController");
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
//    [controller dismissViewControllerAnimated:true completion:nil];
}

@end
