#import "Payfort.h"
#include <CommonCrypto/CommonDigest.h>
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
RCTResponseSenderBlock successCallbackPayfort;
RCTResponseSenderBlock errorCallbackPayfort;

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
//            [rootViewController presentViewController:navigationController animated:NO completion:nil];
            [rootViewController addChildViewController:navigationController];
        }
        NSLog(@"root %@",rootViewController );
        [payFort callPayFortWithRequest:request currentViewController:payFort
                                success:^(NSDictionary *requestDic, NSDictionary *responeDic) { NSLog(@"Success");
            NSLog(@"responeDic=%@",responeDic);
        }
                               canceled:^(NSDictionary *requestDic, NSDictionary *responeDic) { NSLog(@"Canceled");
            NSLog(@"responeDic=%@",responeDic);
        }
                                  faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
            NSLog(@"Faild");
            NSLog(@"responeDic=%@",responeDic);
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

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}

@end
