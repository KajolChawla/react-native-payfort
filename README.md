# react-native-payfort

react native payfort

## Installation

```sh
npm install react-native-payfort
```
# ios
1. add   pod 'PayFortSDK' in pod file

2. open project in xcode Pods > Development Pods > react-native-payfort > Payfort.m change #import  <SDK_location/PayFortSDK-Swift.h> with  SDk location from your Pods > Pods > PayfortSDK > Frameworks > PayFortSDK.xcframework [Drag this "PayFortSDK.xcframework" file directly to "SDK location"]

# android
1. app > build.gradle
```
android{ ...
    viewBinding {
        enabled = true
    }
}
```
2. android > build.gradle
```
dependencies{
    ...
        classpath("com.android.tools.build:gradle:3.6.0")
}
```
## Usage

```js
import { payAmount } from "react-native-payfort";

payAmount(
      {
        command: 'PURCHASE',
        access_code: 'rYsi47ajRWvPeDcWOq8o',
        merchant_identifier: 'LYlVIrli',
        sha_request_phrase: 'O@kmnbvc234',
        amount: '100',
        currencyType: 'SAR',
        currencyCode: 'SAR',
        language: 'en',
        email: 'shubham.d@sankeysolutions.com',
        isProduction: false,
        countryCode: 'SA',
        summaryLabel: 'hello',
      },
      (success: any) => console.log({ success }),
      (error: any) => console.log({ error })
    );
// ...

```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
